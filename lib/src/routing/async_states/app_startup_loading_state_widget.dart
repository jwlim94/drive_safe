import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';

// Splash screen
class AppStartupLoadingStateWidget extends StatelessWidget {
  const AppStartupLoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Drive Safe', style: TextStyles.h1),
      ),
    );
  }
}
