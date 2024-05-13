// import 'package:onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:owomi/common_libs.dart';
import 'package:owomi/ui/screens/onboarding/first_step.dart';
import 'package:sui/sui.dart';
import 'package:zklogin/zklogin.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = ScrollController();
  final suiClient = SuiClient(SuiUrls.devnet);
  var googleFlow = false;

  printAcc() async {
    final account = SuiAccount(Ed25519Keypair());
    final randomness = generateRandomness();

    final epoch = await suiClient.getLatestSuiSystemState();
    final epochInt = int.parse(epoch.epoch);
    print(epochInt);
    final nonce =
        generateNonce(account.keyPair.getPublicKey(), epochInt, randomness);
    print('-----------------------------');
    print(nonce);
    print(account);
    print(randomness);

    setState(() {
      googleFlow = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  // @override
  // Widget build(BuildContext context) {
  //   var width = MediaQuery.of(context).size.width;
  //   return ChangeNotifierProvider()
  // }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Sui zkLogin Dart Demo')),
      body: SingleChildScrollView(
        controller: controller,
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: width < 600 ? 20 : 40,
            horizontal: width < 600 ? 15 : 30,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GoogleSignInPage()
              // const Text('hi'),
              // ElevatedButton(
              //   onPressed: () async {
              //     await printAcc();
              //   },
              //   child: const Text('yoo'),
              // ),
              // googleFlow ? const GoogleSignInPage() : Container()
              FirstStepOnboarding()
            ],
          ),
        ),
      ),
    );
  }
}

// Onboarding(
//       pages: [
//         PageModel(
//           widget: Center(
//             child: TextButton(
//               child: const Text('Home'),
//               onPressed: () => context.go('/home'),
//             ),
//           ),
//         )
//       ],
//     );