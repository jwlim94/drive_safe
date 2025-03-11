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
          //TODO: new logo for AutoFocus
          // Center(
          //   child: SvgPicture.asset(
          //     'assets/images/logo_drive_safe.svg',
          //     width: 250,
          //     height: 450,
          //   ),
          // ),
        ],
      ),
    );
  }
}
