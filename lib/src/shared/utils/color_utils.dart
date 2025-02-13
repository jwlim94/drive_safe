import 'package:drive_safe/src/shared/constants/numbers.dart';
import 'package:flutter/material.dart';

class ColorUtils {
  static List<int> generateRandomColors() {
    final userPrimaryColors = Numbers.userPrimaryColors;
    final userSecondaryColors = Numbers.userSecondaryColors;

    final seed =
        DateTime.now().millisecondsSinceEpoch % userPrimaryColors.length;
    return [userPrimaryColors[seed], userSecondaryColors[seed]];
  }

  static Color toColor(int colorValue) {
    return Color(colorValue);
  }
}
