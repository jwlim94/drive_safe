import 'package:drive_safe/src/features/authentication/application/auth_service.dart';
import 'package:drive_safe/src/features/authentication/presentation/providers/auth_type_state_provider.dart';
import 'package:drive_safe/src/features/authentication/presentation/providers/auth_user_data_state_provider.dart';
import 'package:drive_safe/src/features/car/presentation/providers/car_data_state_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/enums.dart';
import 'package:drive_safe/src/shared/constants/strings.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/utils/crypto_utils.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:drive_safe/src/shared/widgets/custom_dropdown_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class OnboardingVehicleSelectionScreen extends ConsumerStatefulWidget {
  const OnboardingVehicleSelectionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingVehicleSelectionScreenState();
}

class _OnboardingVehicleSelectionScreenState
    extends ConsumerState<OnboardingVehicleSelectionScreen> {
  String? _selectedCarType;
  String? _selectedCarDescription;
  bool _isButtonEnabled = false;

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled =
          _selectedCarType != null && _selectedCarDescription != null;
    });
  }

  void _handleComplete() async {
    // Handle car and league data
    String randomCarId = CryptoUtils.generateRandomId();
    String randomLeagueId = CryptoUtils.generateRandomId();
    ref.read(carDataStateProvider.notifier).setId(randomCarId);
    ref.read(carDataStateProvider.notifier).setType(_selectedCarType!);
    ref
        .read(carDataStateProvider.notifier)
        .setDescription(_selectedCarDescription!);

    // Handle user data
    ref.read(authUserDataStateProvider.notifier).setCarId(randomCarId);
    ref.read(authUserDataStateProvider.notifier).setLeagueId(randomLeagueId);

    // Handle guest
    final AuthType authType = ref.read(authTypeStateProvider);
    if (authType == AuthType.guest) {
      await ref.read(authServiceProvider).signInAnonymously();
      return;
    }

    // Handle sign up
    await ref.read(authServiceProvider).signUp();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(authServiceProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/images/checkered_flag.svg',
            width: double.infinity,
            height: 100,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    const Text(
                      'Vehicle\nCustomization',
                      style: TextStyles.h2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'You can change this later in settings',
                      style: TextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                    // Car Type Section (Required)
                    const SizedBox(height: 36),
                    const Text(
                      'What kind of car do you drive?',
                      style: TextStyles.h4,
                    ),
                    Text(
                      'Required',
                      style: TextStyles.bodyMedium.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomDropdownFormField(
                      items: Strings.vehicleTypes,
                      hintText: 'Select Car',
                      onChanged: (value) {
                        setState(() {
                          _selectedCarType = value;
                          _updateButtonState();
                        });
                      },
                    ),

                    // Car Description Section (Required)
                    const SizedBox(height: 24),
                    const Text(
                      'What best describes your car?',
                      style: TextStyles.h4,
                    ),
                    Text(
                      'Required',
                      style: TextStyles.bodyMedium.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomDropdownFormField(
                      items: Strings.vehicleDescriptions,
                      hintText: 'Select Description',
                      onChanged: (value) {
                        setState(() {
                          _selectedCarDescription = value;
                          _updateButtonState();
                        });
                      },
                    ),

                    // Continue Button Section
                    const SizedBox(height: 36),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: CustomButton(
                        text: "Complete",
                        backgroundColor: AppColors.customPink,
                        borderRadius: 16,
                        onPressed: _isButtonEnabled ? _handleComplete : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
