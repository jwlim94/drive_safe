import 'package:drive_safe/src/features/authentication/application/auth_service.dart';
import 'package:drive_safe/src/features/authentication/presentation/controllers/sign_out_controller.dart';
import 'package:drive_safe/src/features/car/presentation/controllers/update_car_description_controller.dart';
import 'package:drive_safe/src/features/car/presentation/controllers/update_car_type_controller.dart';
import 'package:drive_safe/src/features/car/presentation/providers/current_car_state_provider.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/delete_user_controller.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_colors_controller.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_name_controller.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:drive_safe/src/features/user/presentation/settings/link_account_modal.dart';
import 'package:drive_safe/src/features/user/presentation/settings/delete_account_dialog.dart';
import 'package:drive_safe/src/features/user/presentation/settings/edit_name_modal.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/numbers.dart';
import 'package:drive_safe/src/shared/constants/strings.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/utils/color_utils.dart';
import 'package:drive_safe/src/shared/utils/format_utils.dart';
import 'package:drive_safe/src/shared/widgets/checkered_flag.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:drive_safe/src/shared/widgets/custom_dropdown_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    ref.read(updateUserColorsControllerProvider.notifier).updateUserColors(
          Numbers.userPrimaryColors[index],
          Numbers.userSecondaryColors[index],
        );
  }

  void _handleCarTypeChange(String? value) {
    if (value == null) return;
    ref.read(updateCarTypeControllerProvider.notifier).updateCarType(value);
  }

  void _handleCarDescriptionChange(String? value) {
    if (value == null) return;
    ref
        .read(updateCarDescriptionControllerProvider.notifier)
        .updateCarDesciption(value);
  }

  void _handleEditName() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: AppColors.customWhite,
      builder: (context) {
        return EditNameModal(
          onSave: (newName) {
            ref
                .read(updateUserNameControllerProvider.notifier)
                .updateUserName(newName);
          },
        );
      },
    );
  }

  void _handleCopy(String userCode) async {
    final messenger = ScaffoldMessenger.of(context);

    await Clipboard.setData(ClipboardData(text: userCode));

    messenger.showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleSignOut() {
    ref.read(signOutControllerProvider.notifier).signOut();
  }

  void _handleLinkAccount() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: AppColors.customWhite,
      builder: (context) {
        return LinkAccountModal(
          onSave: (email, password) {
            ref.read(authServiceProvider).anonymousToEmailPassword(
                  email,
                  password,
                );
          },
        );
      },
    );
  }

  void _handleDeleteAccount() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const DeleteAccountDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(updateUserColorsControllerProvider);
    ref.watch(updateUserNameControllerProvider);
    ref.watch(deleteUserControllerProvider);
    ref.watch(updateCarTypeControllerProvider);
    ref.watch(updateCarDescriptionControllerProvider);
    final currentUser = ref.watch(currentUserStateProvider);
    final currentCar = ref.watch(currentCarStateProvider);

    if (currentUser == null) return Container();
    if (currentCar == null) return Container();

    return Stack(
      children: [
        const CheckeredFlag(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(
              color: AppColors.customWhite,
              size: 45,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Text(
                  'SETTINGS',
                  style: TextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                ),

                Flexible(
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Color Change Seciton
                            Row(
                              children: [
                                Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    color: ColorUtils.toColor(
                                        currentUser.primaryColor),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      currentUser.name[0].toUpperCase(),
                                      style: TextStyle(
                                        color: ColorUtils.toColor(
                                            currentUser.secondaryColor),
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
                                        final isSelected =
                                            _selectedIndex == index;

                                        return GestureDetector(
                                          onTap: () => _handleColorClick(index),
                                          child: Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              color: ColorUtils.toColor(Numbers
                                                  .userPrimaryColors[index]),
                                              shape: BoxShape.circle,
                                            ),
                                            child: isSelected
                                                ? Center(
                                                    child: Container(
                                                      width: 16,
                                                      height: 16,
                                                      decoration: BoxDecoration(
                                                        color: ColorUtils
                                                            .toColor(Numbers
                                                                    .userSecondaryColors[
                                                                index]),
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

                            // User Name Section
                            const SizedBox(height: 28),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    currentUser.name,
                                    style: TextStyles.h4,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: _handleEditName,
                                  child: const Icon(
                                    Icons.edit,
                                    color: AppColors.customWhite,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),

                            // User Code Section
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    FormatUtils.formatUserCode(
                                      currentUser.code,
                                    ),
                                    style: TextStyles.h4,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => _handleCopy(currentUser.code),
                                  child: const Icon(
                                    Icons.copy,
                                    color: AppColors.customWhite,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),

                            // Vehicle Type Section
                            const SizedBox(height: 28),
                            CustomDropdownFormField(
                              selectedValue: currentCar.type,
                              items: Strings.vehicleTypes,
                              hintText: 'Select Car',
                              onChanged: (value) => _handleCarTypeChange(value),
                            ),

                            // Vehicle Description Section
                            const SizedBox(height: 16),
                            CustomDropdownFormField(
                              selectedValue: currentCar.description,
                              items: Strings.vehicleDescriptions,
                              hintText: 'Select Description',
                              onChanged: (value) =>
                                  _handleCarDescriptionChange(value),
                            ),

                            // Account Settings Section
                            if (currentUser.isGuest) const SizedBox(height: 28),
                            if (currentUser.isGuest)
                              const Text('Account Settings',
                                  style: TextStyles.h4),
                            if (currentUser.isGuest) const SizedBox(height: 4),
                            if (currentUser.isGuest)
                              GestureDetector(
                                onTap: _handleLinkAccount,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      color: AppColors.customLightPurple,
                                    ),
                                    Text(
                                      'Link Account',
                                      style: TextStyles.h4.copyWith(
                                        color: AppColors.customLightPurple,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Sign Out Section
                            if (!currentUser.isGuest)
                              const SizedBox(height: 32),
                            if (!currentUser.isGuest)
                              CustomButton(
                                text: 'Sign out',
                                backgroundColor: AppColors.customPink,
                                onPressed: _handleSignOut,
                              ),

                            // Delete Account Section
                            if (!currentUser.isGuest)
                              const SizedBox(height: 20),
                            if (!currentUser.isGuest)
                              Center(
                                child: GestureDetector(
                                  onTap: _handleDeleteAccount,
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.delete_forever,
                                        color: AppColors.customWhite,
                                      ),
                                      Text(
                                        ' Delete Account',
                                        style: TextStyles.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
