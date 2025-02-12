import 'package:drive_safe/src/features/authentication/presentation/providers/auth_type_state_provider.dart';
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

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    final bool isEmailValid = email.isEmpty ||
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(email);
    final bool isPasswordValid = password.length >= 8;

    setState(() {
      _isButtonEnabled = isEmailValid && isPasswordValid;
    });
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _handleSignIn() {
    context.goNamed(AppRoute.signIn.name);
  }

  void _handleContinueAsGuest() {
    ref.read(authTypeStateProvider.notifier).setAuthType(AuthType.guest);
    context.goNamed(AppRoute.onboardingBasicInfo.name);
  }

  // TODO: Handle duplicate email
  void _handleSignUp() {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    ref.read(authUserDataStateProvider.notifier).setEmail(email);
    ref.read(authUserDataStateProvider.notifier).setPassword(password);

    // Set auth type
    ref.read(authTypeStateProvider.notifier).setAuthType(AuthType.signUp);

    // Navigate
    context.goNamed(AppRoute.onboardingBasicInfo.name);
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
            SvgPicture.asset(
              'assets/images/checkered_flag.svg',
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
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
                        'Sign Up',
                        style: TextStyles.h2,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: _handleSignIn,
                            child: Text(
                              'Sign In',
                              style: TextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w300,
                                color: AppColors.customPink,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Email Section
                      const SizedBox(height: 28),
                      const Text(
                        'Email',
                        style: TextStyles.h4,
                      ),
                      const SizedBox(height: 12),
                      CustomTextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.text,
                        inputFormatters: InputFormatUtils.emailInputFormatter,
                        hintText: 'example@example.com',
                      ),

                      // Password Section
                      const SizedBox(height: 24),
                      const Text(
                        'Password',
                        style: TextStyles.h4,
                      ),
                      const SizedBox(height: 12),
                      CustomTextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        hintText: 'At least 8 characters',
                      ),

                      // Continue as a Guest Section
                      const SizedBox(height: 36),
                      Row(
                        children: [
                          Text(
                            'No account yet?',
                            style: TextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: _handleContinueAsGuest,
                            child: Text(
                              'Continue as a guest',
                              style: TextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w300,
                                color: AppColors.customPink,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Continue Button Section
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: CustomButton(
                          text: "Continue",
                          backgroundColor: AppColors.customPink,
                          borderRadius: 16,
                          onPressed: _isButtonEnabled ? _handleSignUp : null,
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
