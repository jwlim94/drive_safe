class Session {
  int points;
  Duration timeElapsed;
  bool getAchievement;
  int userGoal;
  int goalCompleteByTime;

  Session({
    required this.points,
    required this.timeElapsed,
    required this.getAchievement,
    required this.userGoal,
    required this.goalCompleteByTime,
  });

  Session copyWith(
      {int? points,
      Duration? timeElapsed,
      int? userGoal,
      bool? getAchievement,
      int? goalCompleteByTime}) {
    return Session(
      points: points ?? this.points,
      timeElapsed: timeElapsed ?? this.timeElapsed,
      getAchievement: getAchievement ?? this.getAchievement,
      userGoal: userGoal ?? this.userGoal,
      goalCompleteByTime: goalCompleteByTime ?? this.goalCompleteByTime,
    );
  }
}
