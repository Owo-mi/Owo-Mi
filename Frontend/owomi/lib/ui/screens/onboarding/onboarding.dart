// import 'package:onboarding/onboarding.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:owomi/common_libs.dart';
import 'package:owomi/logic/zklogin.dart';
import 'package:owomi/provider/zk_login_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final controller = ScrollController();

  String enteredPin = '';
  bool isPinVisible = false;

  @override
  void initState() {
    super.initState();
  }

  // @override
  // Widget build(BuildContext context) {
  //   var width = MediaQuery.of(context).size.width;
  //   return ChangeNotifierProvider()
  // }

  Widget LogoScreen() {
    return SvgPicture.asset(
      'assets/images/logo/logo.svg',
      semanticsLabel: 'Owomi Logo',
      width: 200,
    );
  }

  Widget redirect(BuildContext context) {
    Future(() {
      Zklogin().showSnackBar(context, 'Redirecting');
      context.go('/scafold');
    });
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  Widget firstView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: LogoScreen(),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () =>
                    ref.read(onboardingStepsProvider.notifier).state = 2,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget ZkloginView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: LogoScreen(),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/googlesignin');
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.all(18),
                  backgroundColor: const Color(0xFF111724),
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                child: SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/logo/google/google.svg',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 15),
                      const Text(
                        'Sign in with Google',
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget numButton(int number) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton(
        onPressed: () {
          setState(() {
            if (enteredPin.length < 4) {
              enteredPin += number.toString();
            }
          });
        },
        child: Text(
          number.toString(),
          style: const TextStyle(
              fontSize: 24, color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget inputPinView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const BouncingScrollPhysics(),
      children: [
        SvgPicture.asset(
          'assets/images/logo/logo.svg',
          semanticsLabel: 'Owomi Logo',
          width: 50,
        ),
        const SizedBox(height: 20),
        const Text(
          'Enter Your Pin',
          style: TextStyle(
              fontSize: 40, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Container();
          }),
        ),
      ],
    );
  }

  Widget biometricsView() {
    return Container();
  }

  Widget stepRenderer(BuildContext context) {
    var step = ref.watch(onboardingStepsProvider);
    var onboardingComplete = ref.watch(onboardingCompleteProvider);
    if (onboardingComplete) return redirect(context);
    if (step == 1) {
      return firstView();
    } else if (step == 2) {
      return ZkloginView();
    } else if (step == 3) {
      return inputPinView();
    } else {
      return biometricsView();
    }
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
          child: stepRenderer(context),
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
