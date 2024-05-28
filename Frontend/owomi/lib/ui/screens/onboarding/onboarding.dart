// import 'package:onboarding/onboarding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:owomi/common_libs.dart';
import 'package:owomi/data/storage_manager.dart';
import 'package:owomi/logic/zklogin.dart';
import 'package:owomi/provider/zk_login_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final controller = ScrollController();
  final LocalAuthentication auth = LocalAuthentication();

  String enteredPin = '';
  String enteredConfirmedPin = '';
  bool enteredPinFull = false;
  bool isPinVisible = false;

  late bool canAuthenticateWithBiometrics;

  @override
  void initState() {
    super.initState();
    canAuthenticate();
  }

  finishOnboarding() {
    StorageManager.setOnboardingComplete(true);
    Zklogin().showSnackBar(context, 'Onboarding Complete');
    context.go('/scafold');
  }

  canAuthenticate() async {
    var canAuthenticate = await auth.canCheckBiometrics;
    setState(() {
      canAuthenticateWithBiometrics = canAuthenticate;
      print(canAuthenticateWithBiometrics);
    });
  }

  authenticateWithBiometrics() async {
    late bool didAuthenticate;
    try {
      didAuthenticate = await auth.authenticate(
        localizedReason: 'Authenticate to Unlock Owomi',
        options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: true,
            sensitiveTransaction: true,
            stickyAuth: true),
      );
    } on PlatformException catch (e) {
      print(e);
      if (e.code == auth_error.notEnrolled) {
        Zklogin().showSnackBar(
            context, 'Try enrolling biometrics again in settings page');
        finishOnboarding();
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        Zklogin().showSnackBar(
            context, 'Try enrolling biometrics again in settings page');
        finishOnboarding();
        print('Permanently locked out');
      }
    }
    return didAuthenticate;
  }

  Widget LogoScreen() {
    return SvgPicture.asset(
      'assets/images/logo/logo.svg',
      semanticsLabel: 'Owomi Logo',
      width: 200,
    );
  }

  Widget redirect(BuildContext context) {
    Future(() {
      // Zklogin().showSnackBar(context, 'Redirecting');
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
    var googleSignInComplete = ref.watch(googleSignInCompleteProvider);
    var zkloginProcess = ref.watch(zkloginProcessStatusProvider);
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                zkloginProcess == '' ? Container() : Text(zkloginProcess),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (googleSignInComplete) {
                      return;
                    } else {
                      context.go('/googlesignin');
                    }
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
                  child: googleSignInComplete
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/logo/google.svg',
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
              ],
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
            if (enteredPinFull) {
              if (enteredConfirmedPin.length < 4) {
                enteredConfirmedPin += number.toString();
              }
            } else {
              if (enteredPin.length < 4) {
                enteredPin += number.toString();
              }
            }
            if (!enteredPinFull && enteredPin.length == 4) {
              enteredPinFull = true;
            }
            if (enteredPin.length == 4 && enteredConfirmedPin.length == 4) {
              pinValidator();
            }
            print(enteredPin);
            print(enteredPinFull);
            print(enteredConfirmedPin);
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

  void pinValidator() {
    if (enteredPin == enteredConfirmedPin) {
      savePin();
    } else {
      Zklogin().showSnackBar(context, "Pin doesn't match");
      setState(() {
        enteredPin = '';
        enteredConfirmedPin = '';
        enteredPinFull = false;
      });
    }
  }

  savePin() {
    StorageManager.setUserPin(enteredPin);
    Zklogin().showSnackBar(context, 'Pin Saved');
    ref.read(onboardingStepsProvider.notifier).state = 4;
  }

  Color showPinColor(index) {
    if (enteredPinFull) {
      if (index < enteredConfirmedPin.length) {
        if (isPinVisible) {
          return Colors.green;
        } else {
          return CupertinoColors.activeBlue;
        }
      } else {
        return CupertinoColors.activeBlue.withOpacity(0.1);
      }
    } else {
      if (index < enteredPin.length) {
        if (isPinVisible) {
          return Colors.green;
        } else {
          return CupertinoColors.activeBlue;
        }
      } else {
        return CupertinoColors.activeBlue.withOpacity(0.1);
      }
    }
  }

  Widget inputPinView() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        children: [
          SvgPicture.asset(
            'assets/images/logo/logo.svg',
            semanticsLabel: 'Owomi Logo',
            width: 50,
          ),
          const SizedBox(height: 20),
          Text(
            enteredPinFull ? 'Confirm Your Pin' : 'Enter Your Pin',
            style: const TextStyle(
              fontSize: 40,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),

          /// Pin Code Area
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                margin: const EdgeInsets.all(6.0),
                width: isPinVisible ? 50 : 16,
                height: isPinVisible ? 50 : 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: showPinColor(index),
                ),
                child: enteredPinFull
                    ? isPinVisible && index < enteredConfirmedPin.length
                        ? Center(
                            child: Text(
                              enteredPinFull
                                  ? enteredConfirmedPin[index]
                                  : enteredPin[index],
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: CupertinoColors.systemBlue,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        : null
                    : isPinVisible && index < enteredPin.length
                        ? Center(
                            child: Text(
                              enteredPinFull
                                  ? enteredConfirmedPin[index]
                                  : enteredPin[index],
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: CupertinoColors.systemBlue,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        : null,
              );
            }),
          ),

          /// Visibility toggle button
          IconButton(
            onPressed: () {
              setState(() {
                isPinVisible = !isPinVisible;
              });
            },
            icon: Icon(isPinVisible ? Icons.visibility_off : Icons.visibility),
          ),

          SizedBox(
            height: isPinVisible ? 50.0 : 8.0,
          ),

          /// Digits
          for (var i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  3,
                  (index) => numButton(1 + 3 * i + index),
                ).toList(),
              ),
            ),

          /// 0 digit with backspace
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextButton(
                  onPressed: null,
                  child: SizedBox(),
                ),
                numButton(0),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (enteredPinFull) {
                        if (enteredConfirmedPin.isNotEmpty) {
                          enteredConfirmedPin = enteredConfirmedPin.substring(
                              0, enteredConfirmedPin.length - 1);
                        }
                      } else {
                        if (enteredPin.isNotEmpty) {
                          enteredPin =
                              enteredPin.substring(0, enteredPin.length - 1);
                        }
                      }
                    });
                  },
                  child: const Icon(
                    Icons.backspace,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          ///Reset Button
          TextButton(
            onPressed: () {
              setState(() {
                enteredPin = '';
                enteredConfirmedPin = '';
                enteredPinFull = false;
              });
            },
            child: const Text(
              'Reset',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget biometricsView() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/logo/logo.svg',
                  semanticsLabel: 'Owomi Logo',
                  width: 50,
                ),
                const SizedBox(height: 50),
                SvgPicture.asset(
                  'assets/images/logo/logo.svg',
                  semanticsLabel: 'Owomi Logo',
                  width: 100,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Set up biometrics',
                  style: AppTheme.boldHeading1Text,
                ),
                const Text(
                    'The final step! Setting up biometrics allows you to access owomi more conviniently.',
                    textAlign: TextAlign.center,
                    style: AppTheme.smallText),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                      minimumSize: MaterialStatePropertyAll(
                        Size(200.0, 50.0),
                      ),
                      backgroundColor:
                          MaterialStatePropertyAll(AppTheme.primaryColor),
                    ),
                    onPressed: () async {
                      bool authenticationComplete =
                          await authenticateWithBiometrics();

                      print(authenticationComplete);
                      finishOnboarding();
                    },
                    child: const Text(
                      'Set biometrics',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: const ButtonStyle(
                      minimumSize: MaterialStatePropertyAll(
                        Size(200.0, 50.0),
                      ),
                      backgroundColor:
                          MaterialStatePropertyAll(AppTheme.secondaryColor),
                    ),
                    onPressed: () {
                      finishOnboarding();
                    },
                    child: const Text(
                      'Set up later',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
    } else if (step == 4 && canAuthenticateWithBiometrics) {
      return biometricsView();
    } else {
      return redirect(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var googleSignIn = ref.watch(googleSignInCompleteProvider);
    var zkloginRunning = ref.watch(zkloginInitializeRunningProvider);
    var zkloginComplete = ref.watch(zkloginCompleteProvider);
    var step = ref.watch(onboardingStepsProvider);

    if (!zkloginComplete && step == 2) {
      if (!zkloginRunning) {
        if (googleSignIn) {
          Zklogin().initiate(ref, context);
        }
      }
    } else if (zkloginComplete && step == 2) {
      ref.read(onboardingStepsProvider.notifier).state = 3;
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Container(
        margin: EdgeInsets.symmetric(
          vertical: width < 600 ? 20 : 40,
          horizontal: width < 600 ? 15 : 30,
        ),
        child: stepRenderer(context),
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
