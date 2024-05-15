import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owomi/provider/zk_login_provider.dart';
import 'package:sui/sui.dart';
import 'package:zklogin/zklogin.dart';

class Zklogin {
  final suiClient = SuiClient(SuiUrls.devnet);

  initiate(WidgetRef ref) async {
    var signInComplete = ref.watch(googleSignInCompleteProvider);
    final account = ref.read(suiAccountProvider);
    final randomness = ref.read(randomnessProvider);

    final epoch = await ref.read(epochProvider.future);
    final nonce = ref.read(nonceProvider);
    print('-----------------------------');
    print('Nonce');
    print(nonce);
    print('Account');
    print(account);
    print('Randomness');
    print(randomness);
    print('Epoch');
    print(epoch);
    // if (!signInComplete) {
    //   context.go('/googlesignin');
    // }
    var jwt = ref.watch(jwtProvider);
    var salt = ref.read(saltProvider);
    var extendedEphemeralPublicKey = ref.read(extendedEphemiralPubKeyProvider);
    print('Signin Complete check');
    print(signInComplete);
    print('Jwt');
    print(jwt);
    print('salt');
    print(salt);
    print('extendedEphemiralKey');
    print(extendedEphemeralPublicKey);
    if (signInComplete) {
      if (jwt != '') {
        Map decodedJwt = decodeJwt(jwt);
        print('Decoded Jwt');
        print(decodedJwt);
        var address = jwtToAddress(jwt, BigInt.parse(salt));
        print('Address');
        print(address);
        var proof = await getZkProof(
            jwt, extendedEphemeralPublicKey, epoch, randomness, salt);
        print('Proof');
        print(proof);

        var block = await executeTransactionBlock(
            account, address, salt, jwt, proof, epoch);
        print('Block');
        print(block);
      }
    }
  }

  getZkProof(
      jwt, extendedEphemeralPublicKey, maxEpoch, randomness, salt) async {
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
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }

    final zkProof =
        await Dio().post("https://prover-dev.mystenlabs.com/v1", data: body);

    return zkProof.data;
  }
  // Fund wallet with some sui to gas the transactions

  executeTransactionBlock(
    account,
    address,
    salt,
    jwt,
    zkProof,
    maxEpoch,
  ) async {
    final suiClient = SuiClient(SuiUrls.devnet);
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

  initiateLogin() async {
    // Generate random ephemiral keypair
    //  randomKeypair = SuiAccount(Ed25519Keypair())

    const maxEpoch = 140;

    const randomness = '52093847050252666398858998671021422992';

    // const nonce = 'eXcm9IR3-8p4MAwb3u5dm8T2CvE';

    const jwtStr = 'xxx.yyy.zzz';
    final jwt = decodeJwt(jwtStr);

    final userSalt = BigInt.parse('244579473807694399890185396317414759380');

    final address = jwtToAddress(jwtStr, userSalt);

    final ephemeralKeypair = Ed25519Keypair.fromSecretKey(
        base64Decode('fh+VAX39y3W+C0W1lO7QDxXIsD88426bOoPq1g0P5lU='));

    final extendedEphemeralPublicKey =
        getExtendedEphemeralPublicKey(ephemeralKeypair.getPublicKey());

    final body = {
      "jwt": jwtStr,
      "extendedEphemeralPublicKey": extendedEphemeralPublicKey,
      "maxEpoch": maxEpoch,
      "jwtRandomness": randomness,
      "salt": userSalt.toString(),
      "keyClaimName": "sub",
    };

    final zkProof =
        (await Dio().post('https://prover-dev.mystenlabs.com/v1', data: body))
            .data;

    final txb = TransactionBlock();
    txb.setSenderIfNotSet(address);
    final coin = txb.splitCoins(txb.gas, [txb.pureInt(22222)]);
    txb.transferObjects([coin], txb.pureAddress(address));

    final client = SuiClient(SuiUrls.devnet);
    final sign =
        await txb.sign(SignOptions(signer: ephemeralKeypair, client: client));

    final addressSeed = genAddressSeed(
        userSalt, 'sub', jwt['sub'].toString(), jwt['aud'].toString());
    zkProof["addressSeed"] = addressSeed.toString();

    final zksign = getZkLoginSignature(ZkLoginSignature(
        inputs: ZkLoginSignatureInputs.fromJson(zkProof),
        maxEpoch: maxEpoch,
        userSignature: base64Decode(sign.signature)));

    final resp = await client.executeTransactionBlock(sign.bytes, [zksign],
        options: SuiTransactionBlockResponseOptions(showEffects: true));
    // expect(resp.effects?.status.status, ExecutionStatusType.success);
  }
}
