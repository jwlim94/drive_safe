import 'package:drive_safe/src/features/authentication/presentation/controllers/sign_out_controller.dart';
import 'package:drive_safe/src/features/car/presentation/controllers/update_car_description_controller.dart';
import 'package:drive_safe/src/features/car/presentation/controllers/update_car_type_controller.dart';
import 'package:drive_safe/src/features/car/presentation/providers/current_car_state_provider.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_colors_controller.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/numbers.dart';
import 'package:drive_safe/src/shared/constants/strings.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/utils/color_utils.dart';
import 'package:drive_safe/src/shared/widgets/custom_dropdown_form_field.dart';
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

  @override
  Widget build(BuildContext context) {
    ref.watch(updateUserColorsControllerProvider);
    ref.watch(updateCarTypeControllerProvider);
    ref.watch(updateCarDescriptionControllerProvider);
    final currentUser = ref.watch(currentUserStateProvider);
    final currentCar = ref.watch(currentCarStateProvider);

    if (currentUser == null) return Container();
    if (currentCar == null) return Container();

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
            // Header Section
            Text(
              'SETTINGS',
              style: TextStyles.h3.copyWith(fontWeight: FontWeight.bold),
            ),

            Flexible(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Color Change Seciton
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color:
                                  ColorUtils.toColor(currentUser.primaryColor),
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
                                                      Numbers.userSecondaryColors[
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
                      Text(
                        currentUser.name,
                        style: TextStyles.h4,
                      ),

                      // User ID section
                      // TODO: Get random unique user id
                      const SizedBox(height: 4),
                      const Text('123-456-789', style: TextStyles.h4),

                      // Vehicle Type Section
                      const SizedBox(height: 32),
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

                      // Sign Out Section
                      // TODO: Where should we put sign out button?
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(signOutControllerProvider.notifier)
                              .signOut();
                        },
                        child: const Text('Sign out'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
