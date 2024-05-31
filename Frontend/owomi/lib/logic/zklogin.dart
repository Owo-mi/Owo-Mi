import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owomi/common_libs.dart';
import 'package:owomi/data/constants.dart';
import 'package:owomi/data/storage_manager.dart';
import 'package:owomi/provider/zk_login_provider.dart';
import 'package:sui/sui.dart';
import 'package:sui/types/faucet.dart';
import 'package:zklogin/zklogin.dart';

class Zklogin {
  final suiClient = SuiClient(SuiUrls.testnet);

  initiate(WidgetRef ref, context) async {
    var signInComplete = ref.watch(googleSignInCompleteProvider);
    // Future.delayed(const Duration(seconds: 3), );
    Future(() {
      ref.read(zkloginInitializeRunningProvider.notifier).state = true;
    });

    final account = ref.read(suiAccountProvider);
    final randomness = ref.read(randomnessProvider);

    final epoch = await ref.read(epochProvider.future);

    var jwt = ref.watch(jwtProvider);
    var salt = ref.read(saltProvider);
    var extendedEphemeralPublicKey = ref.read(extendedEphemiralPubKeyProvider);
    var balance = ref.watch(addressBalanceProvider);

    if (signInComplete) {
      if (jwt != '') {
        Map decodedJwt = decodeJwt(jwt);
        await StorageManager.setJwt(jwt);
        await StorageManager.setEmail(decodedJwt['email']);
        var address = jwtToAddress(jwt, BigInt.parse(salt));

        var serverResponse =
            await registerUserInDatabase(address, salt, jwt, ref, context);
        print('From block of code');
        print(serverResponse);
        print(serverResponse['address']);

        if (serverResponse == null) {
          //TODO: Handle error
          // This often occurs so just call the function again
        } else if (serverResponse['address'] != null ||
            serverResponse['address'] != '') {
          address = serverResponse['address'];
          salt = serverResponse['salt'];
        }
        await StorageManager.setAddress(address);

        await requestFaucet(context, ref, address, balance);

        var proof = await getZkProof(jwt, extendedEphemeralPublicKey, epoch,
            randomness, salt, context, ref);

        await executeTransactionBlock(
            account, address, salt, jwt, proof, epoch, ref);
        ref.read(zkloginInitializeRunningProvider.notifier).state = false;
        ref.read(zkloginCompleteProvider.notifier).state = true;
        ref.read(onboardingStepsProvider.notifier).state = 3;
        ref.read(zkloginProcessStatusProvider.notifier).state = '';
      }
    }
  }

  Future<BigInt> requestFaucet(context, WidgetRef ref, address, balance) async {
    Future(() {
      ref.read(zkloginProcessStatusProvider.notifier).state =
          'Requesting gas from faucet';
    });
    var emptyReturn = BigInt.from(0);
    var requesting = ref.watch(makingNetworkRequestProvider);
    if (requesting) return emptyReturn;
    var resp = await suiClient.getBalance(address);
    balance = resp.totalBalance;
    if (balance! <= BigInt.zero) {
      requesting = true;
      try {
        final faucet = FaucetClient(SuiUrls.faucetDev);
        final faucetResp = await faucet.requestSuiFromFaucetV1(address);
        if (faucetResp.task != null) {
          while (true) {
            final statusResp =
                await faucet.getFaucetRequestStatus(faucetResp.task!);
            if (statusResp.status.status == BatchSendStatus.SUCCEEDED) {
              break;
            } else {
              await Future.delayed(const Duration(seconds: 3));
            }
          }
        }
      } catch (e) {
        if (context.mounted) {
          showSnackBar(context, e.toString());
        }
      } finally {
        requesting = false;
      }
    }

    resp = await suiClient.getBalance(address);
    ref.read(addressBalanceProvider.notifier).state = resp.totalBalance;
    return resp.totalBalance;
  }

  getZkProof(jwt, extendedEphemeralPublicKey, maxEpoch, randomness, salt,
      context, ref) async {
    Future(() {
      ref.read(zkloginProcessStatusProvider.notifier).state =
          'Proofing the transaction';
    });
    final body = {
      "jwt": jwt,
      "extendedEphemeralPublicKey": extendedEphemeralPublicKey,
      "maxEpoch": maxEpoch,
      "jwtRandomness": randomness,
      "salt": salt,
      "keyClaimName": "sub",
    };
    try {
      // 404
      final zkProof =
          await Dio().post("https://prover-dev.mystenlabs.com/v1", data: body);

      return zkProof.data;
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        Zklogin().showSnackBar(context, 'Error');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        Zklogin().showSnackBar(context, 'Error');

        print(e.message);
      }
    }

    final zkProof =
        await Dio().post("https://prover-dev.mystenlabs.com/v1", data: body);

    return zkProof.data;
  }
  // Fund wallet with some sui to gas the transactions

  executeTransactionBlock(
      account, address, salt, jwt, zkProof, maxEpoch, ref) async {
    Future(() {
      ref.read(zkloginProcessStatusProvider.notifier).state =
          'Executing Transaction Block';
    });
    final txb = TransactionBlock();
    txb.setSenderIfNotSet(address);
    final coin = txb.splitCoins(txb.gas, [txb.pureInt(22222)]);
    txb.transferObjects([coin], txb.pureAddress(address));
    final sign = await txb.sign(
      SignOptions(
        signer: account!.keyPair,
        client: suiClient,
      ),
    );
    final jwtJson = decodeJwt(jwt);
    final addressSeed = genAddressSeed(
      BigInt.parse(salt),
      "sub",
      jwtJson["sub"].toString(),
      jwtJson["aud"].toString(),
    );
    zkProof["addressSeed"] = addressSeed.toString();
    final zkSign = getZkLoginSignature(
      ZkLoginSignature(
        inputs: ZkLoginSignatureInputs.fromJson(zkProof),
        maxEpoch: maxEpoch,
        userSignature: base64Decode(sign.signature),
      ),
    );
    final resp = await suiClient.executeTransactionBlock(
      sign.bytes,
      [zkSign],
      options: SuiTransactionBlockResponseOptions(showEffects: true),
    );

    return resp.digest;
  }

  void showSnackBar(BuildContext context, String title, {int seconds = 3}) {
    Flushbar(
      icon: const Icon(Icons.info_outline),
      message: title,
      duration: Duration(seconds: seconds),
    ).show(context);
  }

  registerUserInDatabase(address, salt, jwt, ref, context) async {
    Future(() {
      ref.read(zkloginProcessStatusProvider.notifier).state =
          'Saving user in Top-Secret server.';
    });
    final body = {
      "address": address,
      "salt": salt,
    };
    try {
      Response registerUser = await Dio().post(
        "${Constant.backendUrl}/users/registration",
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $jwt",
          },
        ),
      );
      print(registerUser);
      print(registerUser.data);
      return registerUser.data;
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        // Zklogin().showSnackBar(context, 'Error');
        print(e);
        print(e.response);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        Zklogin().showSnackBar(context, 'Error');
        var error = e.message;

        print(e.message);
        // print(e.message?.message);
      }
    }
  }
}
