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
    required this.enduranceMinutes, // ✅ NEW FIELD
    this.lastDriveStreakAt,
    this.userGoal,
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
  final List<String> friends;
  final bool isGuest;
  final int drivePoints;
  final int driveStreak;
  final int enduranceMinutes; // ✅ NEW FIELD
  final int? lastDriveStreakAt;
  final int? userGoal;

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
      enduranceMinutes: map['enduranceMinutes'] ?? 0, // ✅ NEW FIELD
      lastDriveStreakAt: map['lastDriveStreakAt'],
      userGoal: map['userGoal'],
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
      'enduranceMinutes': enduranceMinutes, // ✅ NEW FIELD
      'lastDriveStreakAt': lastDriveStreakAt,
      'userGoal': userGoal,
    };
  }
}
