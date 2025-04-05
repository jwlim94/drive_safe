import 'package:drive_safe/src/features/authentication/presentation/providers/auth_user_data_state_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/enums.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/utils/input_format_utils.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:drive_safe/src/shared/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class OnboardingBasicInfoScreen extends ConsumerStatefulWidget {
  const OnboardingBasicInfoScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingBasicInfoScreenState();
}

class _OnboardingBasicInfoScreenState
    extends ConsumerState<OnboardingBasicInfoScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateButtonState);
    _ageController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final bool hasName = _nameController.text.trim().isNotEmpty;
    final bool hasAge = _ageController.text.trim().isNotEmpty;

    setState(() {
      _isButtonEnabled = hasName && hasAge;
    });
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _handleContinue() {
    final String name = _nameController.text;
    final int age = int.parse(_ageController.text);

    ref.read(authUserDataStateProvider.notifier).setName(name);
    ref.read(authUserDataStateProvider.notifier).setAge(age);

    context.goNamed(AppRoute.onboardingVehicleSelection.name);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _hideKeyboard,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
              width: double.infinity,
              child: SvgPicture.asset(
                'assets/images/checkered_flag.svg',
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.only(left: 40, right: 40, bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      const Text(
                        'Basic\nInformation',
                        style: TextStyles.h2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You can change this later in settings',
                        style: TextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                      ),

                      // Name Section (Required)
                      const SizedBox(height: 28),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Name Section
                          const Flexible(
                            child: Text(
                              'What\'s your name?',
                              style: TextStyles.h4,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Required',
                            style: TextStyles.bodyMedium.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomTextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        inputFormatters: InputFormatUtils.nameInputFormat,
                        hintText: 'Enter Name',
                      ),

                      // Age Section (Required)
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Flexible(
                            child: Text(
                              'How old are you?',
                              style: TextStyles.h4,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Required',
                            style: TextStyles.bodyMedium.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomTextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.text,
                        inputFormatters: InputFormatUtils.ageInputFormat,
                        hintText: 'Enter Age',
                      ),

                      // Continue Button Section
                      const SizedBox(height: 36),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: CustomButton(
                          text: "Continue",
                          backgroundColor: AppColors.customPink,
                          borderRadius: 16,
                          onPressed: _isButtonEnabled ? _handleContinue : null,
                        ),
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
