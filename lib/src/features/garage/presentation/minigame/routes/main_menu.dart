import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/checkered_flag.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key, this.onPlayPressed, this.onSettingsPressed});

  final VoidCallback? onPlayPressed;
  final VoidCallback? onSettingsPressed;

  static const id = 'MainMenu';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CheckeredFlag(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Racing Game', style: TextStyles.h2),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Play',
                  onPressed: onPlayPressed,
                  backgroundColor: AppColors.customPink,
                ),
                const SizedBox(height: 8),
                CustomButton(
                  text: 'Settings',
                  onPressed: onSettingsPressed,
                  backgroundColor: AppColors.customDarkPurple,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
