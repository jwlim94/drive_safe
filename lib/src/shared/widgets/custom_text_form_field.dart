import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
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
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final outlineInputBorder = OutlineInputBorder(
    borderSide: const BorderSide(
      color: AppColors.customDarkGray,
    ),
    borderRadius: BorderRadius.circular(16),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: TextStyles.h4.copyWith(color: AppColors.customDarkGray),
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      cursorColor: AppColors.customDarkGray,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        hintText: widget.hintText,
        hintStyle: TextStyles.h4.copyWith(color: AppColors.customDarkGray),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        focusedErrorBorder: outlineInputBorder,
        errorBorder: outlineInputBorder,
        disabledBorder: outlineInputBorder,
      ),
    );
  }
}
