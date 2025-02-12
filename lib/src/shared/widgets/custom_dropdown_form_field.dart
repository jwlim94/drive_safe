import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatefulWidget {
  const CustomDropdownFormField({
    super.key,
    required this.items,
    required this.onChanged,
    this.hintText,
    this.selectedValue,
  });

  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? hintText;
  final String? selectedValue;

  @override
  State<CustomDropdownFormField> createState() =>
      _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  late String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue;
  }

  final outlineInputBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: AppColors.customDarkGray),
    borderRadius: BorderRadius.circular(16),
  );

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        hintText: widget.hintText,
        hintStyle: TextStyles.h4.copyWith(color: AppColors.customDarkGray),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        errorBorder: outlineInputBorder,
        focusedErrorBorder: outlineInputBorder,
      ),

      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: AppColors.customDarkGray,
      ),

      hint: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.hintText ?? '',
          style: TextStyles.h4.copyWith(color: AppColors.customDarkGray),
        ),
      ),

      // selected item customization
      selectedItemBuilder: (BuildContext context) {
        return widget.items.map((String item) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item,
              style: TextStyles.h4.copyWith(
                color: AppColors.customDarkGray,
              ), // ✅ Selected item in the box is red
            ),
          );
        }).toList();
      },

      // Dropdown menu item customization
      items: widget.items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyles.h4.copyWith(color: AppColors.customBlack),
          ),
        );
      }).toList(),

      onChanged: (newValue) {
        setState(() => selectedValue = newValue);
        widget.onChanged(newValue);
      },
    );
  }
}
