class FormatUtils {
  static String formatUserCode(String userCode) {
    userCode = userCode.padRight(
        12, '0'); //Pad strings in case anything goes wrong during generation.
    return "${userCode.substring(0, 4)}-${userCode.substring(4, 8)}-${userCode.substring(8, 12)}";
  }
}
