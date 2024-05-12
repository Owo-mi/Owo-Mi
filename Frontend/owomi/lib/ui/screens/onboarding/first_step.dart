import 'package:flutter_svg/svg.dart';
import 'package:owomi/common_libs.dart';

class FirstStepOnboarding extends StatelessWidget {
  const FirstStepOnboarding({super.key});

  Widget LogoScreen() {
    return SvgPicture.asset(
      'assets/images/logo/logo.svg',
      semanticsLabel: 'Owomi Logo',
      width: 200,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => context.go('/scafold'),
              ),
            ),
          ),
        )
      ],
    );
  }
}
