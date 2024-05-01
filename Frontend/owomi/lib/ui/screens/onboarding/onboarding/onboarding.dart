// import 'package:onboarding/onboarding.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owomi/common_libs.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

Widget LogoScreen() {
  return SvgPicture.asset(
    'assets/images/logo/logo.svg',
    semanticsLabel: 'Owomi Logo',
    width: 200,
  );
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: LogoScreen(),
        ),
      ],
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