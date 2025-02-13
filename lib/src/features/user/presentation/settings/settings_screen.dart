import 'package:drive_safe/src/features/authentication/presentation/controllers/sign_out_controller.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_colors_controller.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/numbers.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = ref.read(currentUserStateProvider);
      if (currentUser == null) return;

      final index = Numbers.userPrimaryColors.indexOf(currentUser.primaryColor);
      if (index == -1) return;

      setState(() {
        _selectedIndex = index;
      });
    });
  }

  void _handleColorClick(int index) {
    setState(() {
      _selectedIndex = (_selectedIndex == index) ? null : index;
    });

    // Update user colors
    ref.read(updateUserColorsControllerProvider.notifier).updateUserColors(
          Numbers.userPrimaryColors[index],
          Numbers.userSecondaryColors[index],
        );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserStateProvider);
    ref.watch(updateUserColorsControllerProvider);

    // TODO: Handle error state
    if (currentUser == null) return Container();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.customBlack,
        iconTheme: const IconThemeData(
          color: AppColors.customLightPurple,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SETTINGS',
              style: TextStyles.h3.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: ColorUtils.toColor(currentUser.primaryColor),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      currentUser.name[0].toUpperCase(),
                      style: TextStyle(
                        color: ColorUtils.toColor(currentUser.secondaryColor),
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 28),
                Expanded(
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 16,
                    children: List.generate(
                      Numbers.userPrimaryColors.length,
                      (index) {
                        final isSelected = _selectedIndex == index;

                        return GestureDetector(
                          onTap: () => _handleColorClick(index),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: ColorUtils.toColor(
                                  Numbers.userPrimaryColors[index]),
                              shape: BoxShape.circle,
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: ColorUtils.toColor(
                                            Numbers.userSecondaryColors[index]),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () =>
                  ref.read(signOutControllerProvider.notifier).signOut(),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
