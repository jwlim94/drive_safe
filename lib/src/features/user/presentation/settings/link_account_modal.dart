import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/utils/input_format_utils.dart';
import 'package:drive_safe/src/shared/utils/validation_utils.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:drive_safe/src/shared/widgets/custom_password_form_field.dart';
import 'package:drive_safe/src/shared/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class LinkAccountModal extends StatefulWidget {
  const LinkAccountModal({super.key, required this.onSave});

  final void Function(String, String) onSave;

  @override
  State<LinkAccountModal> createState() => _LinkAccountModalState();
}

class _LinkAccountModalState extends State<LinkAccountModal> {
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

    final bool isEmailValid =
        email.isEmpty || ValidationUtils.isValidEmail(email);
    final bool isPasswordValid = ValidationUtils.isValidPassword(password);

    setState(() {
      _isButtonEnabled = isEmailValid && isPasswordValid;
    });
  }

  void _handleSubmit() {
    if (_isButtonEnabled) {
      widget.onSave(_emailController.text.trim(), _passwordController.text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        right: 32,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        left: 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Email',
            style: TextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.customBlack,
            ),
          ),
          const SizedBox(height: 12),
          CustomTextFormField(
            controller: _emailController,
            keyboardType: TextInputType.text,
            inputFormatters: InputFormatUtils.emailInputFormatter,
            hintText: 'example@example.com',
            textColor: AppColors.customBlack,
          ),
          const SizedBox(height: 24),
          Text(
            'Password',
            style: TextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.customBlack,
            ),
          ),
          const SizedBox(height: 12),
          CustomPasswordFormField(
            controller: _passwordController,
            keyboardType: TextInputType.text,
            hintText: 'At least 8 characters',
            textColor: AppColors.customBlack,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Link account',
            backgroundColor: AppColors.customPink,
            onPressed: _isButtonEnabled ? _handleSubmit : null,
          ),
        ],
      ),
    );
  }
}
