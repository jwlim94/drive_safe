class Drive {
  int points;
  Duration timeElapsed;
  bool getAchievement;

  Drive({
    required this.points,
    required this.timeElapsed,
    required this.getAchievement,
  });

  Drive copyWith({int? points, Duration? timeElapsed, bool? getAchievement}) {
    return Drive(
      points: points ?? this.points,
      timeElapsed: timeElapsed ?? this.timeElapsed,
      getAchievement: getAchievement ?? this.getAchievement,
    );
  }
}
