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
    required this.userGoal,
    this.lastDriveStreakAt,
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
  final int userGoal;
  int? lastDriveStreakAt;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      age: map['age'] as int,
      carId: map['carId'] as String,
      email: map['email'] as String,
      primaryColor: map['primaryColor'] as int,
      secondaryColor: map['secondaryColor'] as int,
      code: map['code'] as String,
      leagueId: map['leagueId'] as String,
      friends: map['friends'] as List,
      isGuest: map['isGuest'] as bool,
      drivePoints: map['drivePoints'] as int,
      driveStreak: map['driveStreak'] as int,
      lastDriveStreakAt: map['lastDriveStreakAt'],
      userGoal: map['userGoal'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      // Required fields
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
      'userGoal': userGoal,
    };

    // Optional fields should be added here
    if (lastDriveStreakAt != null) {
      data['lastDriveStreakAt'] = lastDriveStreakAt;
    }

    return data;
  }
}
