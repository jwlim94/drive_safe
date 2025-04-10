import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ExitMenu extends StatelessWidget {
  const ExitMenu({
    super.key,
    this.onRetryPressed,
    this.onExitPressed,
  });

  final VoidCallback? onRetryPressed;
  final VoidCallback? onExitPressed;

  static const id = 'ExitMenu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(210, 229, 238, 238),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Game Over', style: TextStyles.h2),
            const SizedBox(height: 24),
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
