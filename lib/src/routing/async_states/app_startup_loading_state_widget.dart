import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// Splash screen
class AppStartupLoadingStateWidget extends StatelessWidget {
  const AppStartupLoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/checkered_flag.svg',
              fit: BoxFit.fitHeight,
            ),
          ),
          Center(
            child: SvgPicture.asset(
              'assets/images/SplashScreenLogo.svg',
              width: 250,
              height: 450,
            ),
          ),
        ],
      ),
    );
  }
}
