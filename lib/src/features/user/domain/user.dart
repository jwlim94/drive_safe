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
    required this.enduranceMinutes,
    required this.goalCompleteByTime,
    this.lastDriveStreakAt,
    required this.userGoal,
    this.badges, // ✅ 생성자 안에 들어가야 함!
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
  final List<String>? badges; // ✅ 이건 필드 선언 위치가 맞음
  int goalCompleteByTime;
  int userGoal;
  int? lastDriveStreakAt;
  final int enduranceMinutes;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      carId: map['carId'],
      email: map['email'],
      primaryColor: map['primaryColor'],
      secondaryColor: map['secondaryColor'],
      code: map['code'],
      leagueId: map['leagueId'],
      friends: List<String>.from(map['friends'] ?? []),
      isGuest: map['isGuest'] ?? false,
      drivePoints: map['drivePoints'] ?? 0,
      driveStreak: map['driveStreak'] ?? 0,
      enduranceMinutes: map['enduranceMinutes'] ?? 0,
      lastDriveStreakAt: map['lastDriveStreakAt'],
      badges: List<String>.from(map['badges'] ?? []),
      userGoal: map['userGoal'] as int,
      goalCompleteByTime: map['goalCompleteByTime'] as int,
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
      'enduranceMinutes': enduranceMinutes,
      'lastDriveStreakAt': lastDriveStreakAt,
      'badges': badges,
      'userGoal': userGoal,
      'goalCompleteByTime': goalCompleteByTime,
    };
  }

  /// ✅ copyWith
  User copyWith({
    List<String>? badges,
    int? enduranceMinutes,
    int? driveStreak,
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
      friends: friends,
      isGuest: isGuest,
      drivePoints: drivePoints,
      driveStreak: driveStreak ?? this.driveStreak,
      enduranceMinutes: enduranceMinutes ?? this.enduranceMinutes,
      lastDriveStreakAt: lastDriveStreakAt,
      userGoal: userGoal,
      badges: badges ?? this.badges,
      goalCompleteByTime: this.goalCompleteByTime,
    );
  }
}
