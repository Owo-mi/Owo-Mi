// import 'package:onboarding/onboarding.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owomi/common_libs.dart';
import 'package:owomi/logic/zklogin.dart';
import 'package:owomi/provider/zk_login_provider.dart';
import 'package:sui/sui.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final controller = ScrollController();
  final suiClient = SuiClient(SuiUrls.devnet);
  var googleFlow = false;

  @override
  void initState() {
    super.initState();
  }

  // @override
  // Widget build(BuildContext context) {
  //   var width = MediaQuery.of(context).size.width;
  //   return ChangeNotifierProvider()
  // }

  Widget redirect(BuildContext context) {
    Future(() {
      Zklogin().showSnackBar(context, 'Redirecting');
      context.go('/scafold');
    });
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var googleSignIn = ref.watch(googleSignInCompleteProvider);
    var zkloginRunning = ref.watch(zkloginInitializeRunningProvider);
    var zkloginComplete = ref.watch(zkloginCompleteProvider);
    if (!zkloginComplete) {
      if (!zkloginRunning) {
        if (googleSignIn) {
          Zklogin().initiate(ref, context);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Sui zkLogin Dart Demo')),
      body: SingleChildScrollView(
        controller: controller,
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: width < 600 ? 20 : 40,
            horizontal: width < 600 ? 15 : 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GoogleSignInPage()
              zkloginComplete ? redirect(context) : Container(),
              const Text('hi'),
              ElevatedButton(
                onPressed: () {
                  context.go('/googlesignin');
                },
                child: const Text('yoo'),
              ),
              // googleFlow ? const GoogleSignInPage() : Container()
              // FirstStepOnboarding()
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