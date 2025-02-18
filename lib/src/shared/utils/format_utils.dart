class FormatUtils {
  static String formatUserCode(String userCode) {
    return "${userCode.substring(0, 4)}-${userCode.substring(4, 8)}-${userCode.substring(8, 12)}";
  }
}
