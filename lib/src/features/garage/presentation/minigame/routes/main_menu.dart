import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/checkered_flag.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainMenu extends ConsumerWidget {
  const MainMenu({super.key, this.onPlayPressed, this.onSettingsPressed});

  final VoidCallback? onPlayPressed;
  final VoidCallback? onSettingsPressed;

  static const id = 'MainMenu';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserStateProvider);

    void showRequiredFocusTimeDialog(int remainingSeconds) {
      final minutes = remainingSeconds ~/ 60;
      final seconds = remainingSeconds % 60;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Additional Focus Time Required'),
          content: Text(
            'You need ${minutes}m ${seconds}s more focus time before starting the game.\n\nPlease complete your Focus Time in the Home screen and try again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

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
                  onPressed: () {
                    if (currentUser == null) return;

                    if (currentUser.requiredFocusTimeInSeconds > 0) {
                      showRequiredFocusTimeDialog(
                          currentUser.requiredFocusTimeInSeconds);
                    } else {
                      onPlayPressed?.call();
                    }
                  },
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
