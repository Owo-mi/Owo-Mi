// import 'package:onboarding/onboarding.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owomi/common_libs.dart';
import 'package:owomi/data/storage_manager.dart';
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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    ZkLoginStorageManager.clear();
    var googleSignIn = ref.watch(googleSignInCompleteProvider);
    if (googleSignIn) {
      Zklogin().initiate(ref);
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