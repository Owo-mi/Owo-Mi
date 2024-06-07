import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owomi/common_libs.dart';
import 'package:owomi/data/constants.dart';
import 'package:owomi/data/storage_manager.dart';
import 'package:owomi/logic/zklogin.dart';
import 'package:sui/sui.dart';

import '../provider/zk_login_provider.dart';

class AppLogic {
  warmUpForTransaction(WidgetRef ref, BuildContext context) async {
    Future(() {
      ref.read(zkloginProcessStatusProvider.notifier).state =
          'Warming up for bulky transaction';
    });

    var responseFromSaltTransaction = await getUserInformation(ref);
    if (!ref.read(recentlyRequestedEpochProvider)) {
      var raw = await suiClient.getLatestSuiSystemState();
      var epoch = int.parse(raw.epoch);
      await StorageManager.setTemporaryMaxEpoch(epoch);
    }
    var epoch = StorageManager.getTemporaryMaxEpoch();
    var extendedEphemeralPublicKey = ref.read(extendedEphemiralPubKeyProvider);
    final randomness = ref.read(randomnessProvider);
    final account = ref.read(suiAccountProvider);
    final address = StorageManager.getAddress();
    ref.read(googleSignInCompleteProvider.notifier).state = false;

    // if (responseFromSaltTransaction == null) {
    //   Future(() {
    //     ref.read(zkloginProcessStatusProvider.notifier).state =
    //         'Error, please try again';
    //   });
    //   return;
    // }
    print('main function body');
    print(responseFromSaltTransaction);

    if (responseFromSaltTransaction == null) {
      // if (responseFromSaltTransaction['message'] == "Forbidden") {
      var allowed = false;
      Future(
        () {
          ref.read(zkloginProcessStatusProvider.notifier).state =
              'Awaiting user response';

          // showDialog(
          //   context: context,
          //   builder: (context) => SimpleDialog(
          //     title: const Text("Re-establish Connection"),
          //     children: [
          //       const Padding(
          //         padding: EdgeInsets.all(8.0),
          //         child: Text(
          //             'Owomi needs to establish a connection with Google to sign the transaction'),
          //       ),
          //       Row(
          //         children: [
          //           TextButton(
          //             onPressed: () {
          //               allowed = false;
          //               Navigator.pop(context);
          //               return;
          //             },
          //             child: const Text('No'),
          //           ),
          //           TextButton(
          //             onPressed: () {
          //               allowed = true;
          //               context.push('/googlesignin?transaction=true');
          //             },
          //             child: const Text('Sure'),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // );
        },
      );
      context.push('/googlesignin?transaction=true');

      // if (allowed) {
      //   context.push('/googlesignin?transaction=true');
      // }
      // }
    } else {
      var jwt = StorageManager.getJwt();
      if (jwt != "") {
        var salt = await getUserInformation(ref);

        if (salt['salt'] != "" && salt['salt'] != null) {
          var proof = await Zklogin().getZkProof(
              jwt,
              extendedEphemeralPublicKey,
              epoch,
              randomness,
              salt['salt'],
              context,
              ref);

          await Zklogin().executeTransactionBlock(
              account, address, salt['salt'], jwt, proof, epoch, ref);
          Future(() {
            ref.read(zkloginProcessStatusProvider.notifier).state = '';
          });
        }
      }
    }
  }

  getUserInformation(WidgetRef ref) async {
    var jwt = StorageManager.getJwt();

    try {
      Future(() {
        ref.read(zkloginProcessStatusProvider.notifier).state =
            'Retrieving user saltiness';
      });
      final getUser = await Dio().get(
        "${Constant.backendUrl}/users/salt",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $jwt",
          },
        ),
      );
      print(getUser);
      print(getUser.data);
      return getUser.data;
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        // Zklogin().showSnackBar(context, 'Error');
        print(e);
        print(e.response);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        // Zklogin().showSnackBar(context, 'Error');

        print(e.message);
        return e.message;
        // print(e.message?.message);
      }
    }
  }

  regularSavings(String? coinType, String? name, String? description,
      String? address, Map? target) async {
    // var jwt = StorageManager.getJwt();
    // print(jwt);

    try {
      final body = {
        "coinType": coinType,
        "name": name,
        "description": description,
        "target": target,
        "address": address,
      };
      final getUser = await Dio().post(
        "${Constant.backendUrl}/savings",
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            // "Authorization": "Bearer $jwt",
          },
        ),
      );
      print(getUser);
      print(getUser.data);
      print(getUser.data['data']);
      return getUser.data['data'];
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        // Zklogin().showSnackBar(context, 'Error');
        print(e);
        print(e.response);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        // Zklogin().showSnackBar(context, 'Error');

        print(e.message);
        // print(e.message?.message);
      }
    }
  }

  signTransactions(String? coinType, String? name, String? description,
      String? address, Map? target, ref) async {
    final account = ref.read(suiAccountProvider);
    final suiClient = SuiClient(SuiUrls.devnet, account: account);

    var serialized =
        await regularSavings(coinType, name, description, address, target);

    final txb = TransactionBlock.from(serialized);
    txb.setSender(address!);
    // var res = await suiClient.s
    print('from sign transaction function');
    var txBytes = await txb.build(BuildOptions(client: suiClient));
    final result =
        await suiClient.signAndExecuteTransaction(transaction: txBytes);
    print(result);
    print(result.digest);
    print(result.confirmedLocalExecution);
  }

  truncateString(String input) {
    if (input.length <= 8) {
      return input;
    }
    String firstPart = input.substring(0, 4);
    String lastPart = input.substring(input.length - 4);
    return '$firstPart...$lastPart';
  }

  truncateEmail(String email) {
    List<String> parts = email.split('@');
    if (parts.length != 2) {
      return email;
    }

    String username = parts[0];
    String domain = '@${parts[1]}';

    if (username.length <= 6) {
      return email;
    }

    String firstPart = username.substring(0, 4);
    String lastPart = username.substring(username.length - 4);

    return '$firstPart...$lastPart$domain';
  }
}
