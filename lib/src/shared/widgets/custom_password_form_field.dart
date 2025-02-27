import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomPasswordFormField extends StatefulWidget {
  const CustomPasswordFormField({
    super.key,
    required this.controller,
    required this.keyboardType,
    this.inputFormatters,
    this.hintText,
    this.onChanged,
  });

  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;
  final ValueChanged<String>? onChanged;

  @override
  State<CustomPasswordFormField> createState() =>
      _CustomPasswordFormFieldState();
}

class _CustomPasswordFormFieldState extends State<CustomPasswordFormField> {
  final outlineInputBorder = OutlineInputBorder(
    borderSide: const BorderSide(
      color: AppColors.customDarkGray,
    ),
    borderRadius: BorderRadius.circular(16),
  );
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: TextStyles.h4.copyWith(color: AppColors.customDarkGray),
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      cursorColor: AppColors.customDarkGray,
      onChanged: widget.onChanged,
      obscureText: _isHidden,
      obscuringCharacter: '*',
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          hintText: widget.hintText,
          hintStyle: TextStyles.h4.copyWith(color: AppColors.customDarkGray),
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          focusedErrorBorder: outlineInputBorder,
          errorBorder: outlineInputBorder,
          disabledBorder: outlineInputBorder,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isHidden = !_isHidden;
              });
            },
            icon: Icon(_isHidden ? Icons.visibility_off : Icons.visibility),
          )),
    );
  }
}
