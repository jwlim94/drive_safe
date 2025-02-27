import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double verticalPadding;
  final double horizontalPadding;
  final double borderRadius;
  final Color borderOutline;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = Colors.black,
    this.foregroundColor = Colors.white,
    this.verticalPadding = 12,
    this.horizontalPadding = 16,
    this.borderRadius = 12,
    this.borderOutline = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: borderOutline, width: 2),
        disabledBackgroundColor: AppColors.customDarkGray,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
      ),
      child: Text(
        text,
        style: TextStyles.h4.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
