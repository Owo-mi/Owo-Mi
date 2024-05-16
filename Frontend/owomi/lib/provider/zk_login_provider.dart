import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owomi/data/constants.dart';
import 'package:owomi/data/storage_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sui/sui.dart';
import 'package:sui/types/faucet.dart';
import 'package:zklogin/zklogin.dart';

final suiClient = SuiClient(SuiUrls.devnet);

final suiAccountProvider = Provider<SuiAccount>((ref) {
  var keypair = ZkLoginStorageManager.getTemporaryCacheKeyPair();
  if (keypair == '') {
    keypair = SuiAccount(Ed25519Keypair()).privateKeyHex();
    ZkLoginStorageManager.setTemporaryCacheKeyPair(keypair);
  }
  var account = SuiAccount.fromPrivateKey(keypair, SignatureScheme.Ed25519);
  return account;
});

final extendedEphemiralPubKeyProvider = Provider<String>((ref) {
  return getExtendedEphemeralPublicKey(
      ref.watch(suiAccountProvider).keyPair.getPublicKey());
});

final randomnessProvider = Provider<String>((ref) {
  var randomness = ZkLoginStorageManager.getTemporaryRandomness();
  if (randomness == '') {
    randomness = generateRandomness();
    ZkLoginStorageManager.setTemporaryRandomness(randomness);
  }
  return randomness;
});

final saltProvider = Provider<String>((ref) {
  return generateRandomness();
});

final jwtProvider = StateProvider<String>((ref) {
  return '';
});

final onboardingStepsProvider = StateProvider<int>((ref) {
  return 1;
});

final onboardingCompleteProvider = StateProvider<bool>((ref) {
  return ZkLoginStorageManager.getOnboardingComplete();
});

final googleSignInCompleteProvider = StateProvider<bool>((ref) {
  return false;
});
final zkloginInitializeRunningProvider = StateProvider<bool>((ref) {
  return false;
});

final zkloginCompleteProvider = StateProvider<bool>((ref) {
  return false;
});

final addressBalanceProvider = StateProvider<BigInt>((ref) {
  var big = BigInt.from(0);
  return big;
});

final makingNetworkRequestProvider = StateProvider<bool>((ref) {
  return false;
});

final epochProvider = FutureProvider<int>((ref) async {
  var epoch = ZkLoginStorageManager.getTemporaryMaxEpoch();
  if (epoch == 0) {
    var raw = await suiClient.getLatestSuiSystemState();
    epoch = int.parse(raw.epoch);
    ZkLoginStorageManager.setTemporaryMaxEpoch(epoch);
  }
  return epoch;
});

final nonceProvider = FutureProvider<String>((ref) async {
  var nonce = ZkLoginStorageManager.getTemporaryCacheNonce();
  if (nonce == '') {
    final account = ref.read(suiAccountProvider);
    final epoch = await ref.read(epochProvider.future);
    final randomness = ref.read(randomnessProvider);
    nonce = generateNonce(account.keyPair.getPublicKey(), epoch, randomness);
    ZkLoginStorageManager.setTemporaryCacheNonce(nonce);
  }
  return nonce;
});

final googleUrlProvider = FutureProvider<String>((ref) async {
  final nonce = await ref.read(nonceProvider.future);
  // final jwt = ref.watch(jwtProvider);
  return 'https://accounts.google.com/o/oauth2/v2/auth/oauthchooseaccount?client_id=${Constant.googleClientId}&response_type=id_token&redirect_uri=${Constant.redirectUrl}&scope=openid&nonce=$nonce&service=lso&o2v=2&theme=mn&ddm=0&flowName=GeneralOAuthFlow&id_token=%7D';
});

@riverpod
class ZkLoginProvider {
  final suiClient = SuiClient(SuiUrls.devnet);

  SuiAccount? _account;

  SuiAccount? get account {
    if (_account != null) return _account;
    final privKey = ZkLoginStorageManager.getTemporaryCacheKeyPair();
    if (privKey.isEmpty) return null;
    return SuiAccount.fromPrivateKey(privKey, SignatureScheme.Ed25519);
  }

  set account(SuiAccount? value) {
    _account = value;
    ZkLoginStorageManager.setTemporaryCacheKeyPair(
      value?.privateKeyHex() ?? '',
    );
  }

  int _step = 1;

  int get step => _step;

  set step(int value) {
    _step = value;
  }

  int _maxEpoch = 0;

  int get maxEpoch => _maxEpoch;

  set maxEpoch(int value) {
    _maxEpoch = value;
    ZkLoginStorageManager.setTemporaryMaxEpoch(value);
  }

  String _randomness = '';

  String get randomness => _randomness;

  set randomness(String value) {
    _randomness = value;
    ZkLoginStorageManager.setTemporaryRandomness(value);
  }

  String _nonce = '';

  String get nonce => _nonce;

  set nonce(String value) {
    _nonce = value;
    ZkLoginStorageManager.setTemporaryCacheNonce(nonce);
  }

  String _salt = '';

  String get salt => _salt;

  set salt(String value) {
    _salt = value;
  }

  String _address = '';

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String _extendedEphemeralPublicKey = '';

  String get extendedEphemeralPublicKey => _extendedEphemeralPublicKey;

  set extendedEphemeralPublicKey(String value) {
    _extendedEphemeralPublicKey = value;
  }

  BigInt? _balance;

  BigInt? get balance => _balance;

  set balance(BigInt? value) {
    _balance = value;
  }

  bool _requesting = false;

  bool get requesting => _requesting;

  set requesting(bool value) {
    _requesting = value;
  }

  getCurrentEpoch() async {
    final result = await suiClient.getLatestSuiSystemState();
    maxEpoch = int.parse(result.epoch) + 10;
  }

  String _jwt = '';

  String get jwt => _jwt;

  set jwt(String value) {
    _jwt = value;
  }

  String _userIdentifier = '';

  String get userIdentifier => _userIdentifier;

  set userIdentifier(String value) {
    _userIdentifier = value;
  }

  String _email = '';

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  Map<String, dynamic> _zkProof = {};

  Map<String, dynamic> get zkProof => _zkProof;

  set zkProof(Map<String, dynamic> value) {
    _zkProof = value;
  }

  String get googleLoginUrl =>
      'https://accounts.google.com/o/oauth2/v2/auth/oauthchooseaccount?'
      'client_id=${Constant.googleClientId}&response_type=id_token'
      '&redirect_uri=${kIsWeb ? Uri.encodeComponent(Constant.redirectUrl) : Constant.redirectUrl}&scope=openid&nonce=$nonce'
      '&service=lso&o2v=2&theme=mn&ddm=0&flowName=GeneralOAuthFlow'
      '&id_token=$jwt}';

  getBalance() {
    if (address.isNotEmpty) {
      suiClient.getBalance(address).then((res) {
        balance = res.totalBalance;
      });
    }
  }

  void requestFaucet(BuildContext context) async {
    if (requesting) return;
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
    balance = resp.totalBalance;
  }

  void showSnackBar(BuildContext context, String title, {int seconds = 3}) {
    Flushbar(
      icon: const Icon(Icons.info_outline),
      message: title,
      duration: Duration(seconds: seconds),
    ).show(context);
  }

  getZkProof(BuildContext context) async {
    if (requesting) return;
    requesting = true;
    try {
      final param = {
        "jwt": jwt,
        "extendedEphemeralPublicKey": extendedEphemeralPublicKey,
        "maxEpoch": maxEpoch,
        "jwtRandomness": randomness,
        "salt": salt,
        "keyClaimName": "sub",
      };

      final data = await Dio().post(
        'https://prover-dev.mystenlabs.com/v1',
        data: param,
      );
      zkProof = data.data as Map<String, dynamic>;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), seconds: 6);
      }
    } finally {
      requesting = false;
    }
  }

  Future<String?> executeTransactionBlock(BuildContext context) async {
    String? digest;
    try {
      if (requesting) return digest;
      requesting = true;
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
        'sub',
        jwtJson['sub'].toString(),
        jwtJson['aud'].toString(),
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
        requestType: ExecuteTransaction.WaitForLocalExecution,
      );
      if (resp.confirmedLocalExecution == true) {
        digest = resp.digest;
        getBalance();
      } else {
        if (context.mounted) {
          showSnackBar(context, "Transaction Send Failed");
        }
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), seconds: 6);
      }
    } finally {
      requesting = false;
    }
    return digest;
  }
}
