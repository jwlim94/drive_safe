import 'package:json_annotation/json_annotation.dart';

part 'auth_user_data.g.dart';

@JsonSerializable()
class AuthUserData {
  AuthUserData({
    this.id,
    this.name,
    this.age,
    this.carId,
    this.email,
    this.password,
    this.leagueId,
    this.friends,
    this.userGoal,
  });

  final String? id;
  final String? name;
  final int? age;
  final String? carId;
  final String? email;
  final String? password;
  final String? leagueId;
  final List? friends;
  final int? userGoal;

  factory AuthUserData.fromJson(Map<String, dynamic> json) =>
      _$AuthUserDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserDataToJson(this);
}
