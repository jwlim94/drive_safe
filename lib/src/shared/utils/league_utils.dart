class LeagueUtils {
  static String getSvgPath(String name) {
    return 'assets/images/${name}_trophy.svg';
  }

  static String getFormattedLeagueName(String name) {
    String capitalized = name[0].toUpperCase() + name.substring(1);
    return '$capitalized League';
  }
}
