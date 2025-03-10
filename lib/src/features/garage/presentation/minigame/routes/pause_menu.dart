import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class PauseMenu extends StatelessWidget {
  const PauseMenu({
    super.key,
    this.onResumePressed,
    this.onRestartPressed,
    this.onExitPressed,
  });

  final VoidCallback? onResumePressed;
  final VoidCallback? onRestartPressed;
  final VoidCallback? onExitPressed;

  static const id = 'PauseMenu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // To make background still visible
      backgroundColor: const Color.fromARGB(210, 229, 238, 238),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Paused', style: TextStyles.h2),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Resume',
              onPressed: onResumePressed,
              backgroundColor: AppColors.customPink,
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: 'Restart',
              onPressed: onRestartPressed,
              backgroundColor: AppColors.customDarkPurple,
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: 'Exit',
              onPressed: onExitPressed,
              backgroundColor: AppColors.customDarkGray,
            ),
          ],
        ),
      ),
    );
  }
}
