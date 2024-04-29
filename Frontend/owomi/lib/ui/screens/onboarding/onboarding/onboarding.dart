import 'package:onboarding/onboarding.dart';
import 'package:owomi/common_libs.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Onboarding(
      pages: [
        PageModel(
          widget: Center(
            child: TextButton(
              child: const Text('Home'),
              onPressed: () => context.go('/home'),
            ),
          ),
        )
      ],
    );
  }
}
