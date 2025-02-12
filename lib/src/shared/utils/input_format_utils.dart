import 'package:flutter/services.dart';

class InputFormatUtils {
  static final nameInputFormat = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
    LengthLimitingTextInputFormatter(24),
  ];

  static final ageInputFormat = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  ];

  static final emailInputFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._\-+]')),
    LengthLimitingTextInputFormatter(120),
  ];
}
