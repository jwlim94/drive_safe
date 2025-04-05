import 'package:drive_safe/src/features/authentication/application/auth_service.dart';
import 'package:drive_safe/src/features/authentication/presentation/providers/auth_type_state_provider.dart';
import 'package:drive_safe/src/features/authentication/presentation/providers/auth_user_data_state_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/enums.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/utils/input_format_utils.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:drive_safe/src/shared/widgets/custom_password_form_field.dart';
import 'package:drive_safe/src/shared/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
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

  void _handleSignUp() {
    context.goNamed(AppRoute.signUp.name);
  }

  // TODO: Handle does not exist email
  void _handleSignIn() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    ref.read(authUserDataStateProvider.notifier).setEmail(email);
    ref.read(authUserDataStateProvider.notifier).setPassword(password);

    // Set auth type
    ref.read(authTypeStateProvider.notifier).setAuthType(AuthType.signIn);

    // Handle sign in
    await ref.read(authServiceProvider).signIn();
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
                        'Sign In',
                        style: TextStyles.h2,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: _handleSignUp,
                            child: Text(
                              'Sign Up',
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
                        hintText: 'Enter Email',
                      ),

                      // Password Section
                      const SizedBox(height: 24),
                      const Text(
                        'Password',
                        style: TextStyles.h4,
                      ),
                      const SizedBox(height: 12),
                      CustomPasswordFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        hintText: 'Enter Password',
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
                          onPressed: _isButtonEnabled ? _handleSignIn : null,
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
