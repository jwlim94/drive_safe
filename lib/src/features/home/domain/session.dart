class Session {
  int points;
  Duration timeElapsed;
  bool getAchievement;
  int userGoal;

  Session({
    required this.points,
    required this.timeElapsed,
    required this.getAchievement,
    required this.userGoal,
  });

  Session copyWith(
      {int? points,
      Duration? timeElapsed,
      int? userGoal,
      bool? getAchievement}) {
    return Session(
      points: points ?? this.points,
      timeElapsed: timeElapsed ?? this.timeElapsed,
      getAchievement: getAchievement ?? this.getAchievement,
      userGoal: userGoal ?? this.userGoal,
    );
  }
}
