import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    required this.id,
    required this.name,
    required this.age,
    required this.carId,
    required this.email,
    required this.primaryColor,
    required this.secondaryColor,
    required this.code,
    required this.leagueId,
    required this.friends,
    required this.isGuest,
    required this.drivePoints,
    required this.driveStreak,
    required this.enduranceSeconds,
    required this.goalCompleteByTime,
    this.lastDriveStreakAt,
    required this.userGoal,
    required this.highestScore,
    required this.requiredFocusTimeInSeconds,
    this.badges = const [],
  });

  final String id;
  final String name;
  final int age;
  final String carId;
  final String email;
  final int primaryColor;
  final int secondaryColor;
  final String code;
  final String leagueId;
  final List friends;
  final bool isGuest;
  final int drivePoints;
  final int driveStreak;

  @JsonKey(
    defaultValue: [],
    fromJson: customBadgesFromJson,
  )
  final List<String> badges;

  int goalCompleteByTime;
  int userGoal;
  int? lastDriveStreakAt;
  final int enduranceSeconds;
  final int highestScore;
  final int requiredFocusTimeInSeconds;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Unknown',
      age: map['age'] ?? 0,
      carId: map['carId'] ?? '',
      email: map['email'] ?? '',
      primaryColor: map['primaryColor'] ?? 0,
      secondaryColor: map['secondaryColor'] ?? 0,
      code: map['code'] ?? '',
      leagueId: map['leagueId'] ?? '',
      friends: List<String>.from(map['friends'] ?? []),
      isGuest: map['isGuest'] ?? false,
      drivePoints: map['drivePoints'] ?? 0,
      driveStreak: map['driveStreak'] ?? 0,
      enduranceSeconds: map['enduranceSeconds'] ?? 0,
      lastDriveStreakAt: map['lastDriveStreakAt'],
      badges: customBadgesFromJson(map['badges']),
      userGoal: map['userGoal'] ?? 0,
      goalCompleteByTime: map['goalCompleteByTime'] ?? 0,
      highestScore: map['highestScore'] ?? 0,
      requiredFocusTimeInSeconds: map['requiredFocusTimeInSeconds'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'carId': carId,
      'email': email,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'code': code,
      'leagueId': leagueId,
      'friends': friends,
      'isGuest': isGuest,
      'drivePoints': drivePoints,
      'driveStreak': driveStreak,
      'enduranceSeconds': enduranceSeconds,
      'lastDriveStreakAt': lastDriveStreakAt,
      'badges': badges,
      'userGoal': userGoal,
      'goalCompleteByTime': goalCompleteByTime,
      'highestScore': highestScore,
      'requiredFocusTimeInSeconds': requiredFocusTimeInSeconds,
    };
  }

  User copyWith({
    List<String>? badges,
    int? enduranceSeconds,
    int? driveStreak,
    int? highestScore,
    int? requiredFocusTimeInSeconds,
    List<dynamic>? friends,
  }) {
    return User(
      id: id,
      name: name,
      age: age,
      carId: carId,
      email: email,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      code: code,
      leagueId: leagueId,
      friends: friends ?? this.friends,
      isGuest: isGuest,
      drivePoints: drivePoints,
      driveStreak: driveStreak ?? this.driveStreak,
      enduranceSeconds: enduranceSeconds ?? this.enduranceSeconds,
      lastDriveStreakAt: lastDriveStreakAt,
      userGoal: userGoal,
      badges: badges ?? this.badges,
      goalCompleteByTime: goalCompleteByTime,
      highestScore: highestScore ?? this.highestScore,
      requiredFocusTimeInSeconds:
          requiredFocusTimeInSeconds ?? this.requiredFocusTimeInSeconds,
    );
  }
}

List<String> customBadgesFromJson(dynamic value) {
  if (value == null) return [];
  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }
  return [];
}
