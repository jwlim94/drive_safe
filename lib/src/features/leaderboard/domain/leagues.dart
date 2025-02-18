import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';

class League {
  String svgPath;
  String name;
  int leagueTier;
  Color color;
  int position;
  String userId;

  League({
    this.svgPath = '',
    required this.name,
    required this.leagueTier,
    required this.color,
    this.position = 0,
    this.userId = '',
  });
  static List<League> getLeagues() {
    List<League> leagues = [];

    leagues.add(League(
        svgPath: 'assets/images/bronze_trophy.svg',
        name: 'Bronze League',
        leagueTier: 0,
        color: AppColors.bronzeLeague));

    leagues.add(League(
        svgPath: 'assets/images/silver_trophy.svg',
        name: 'Silver League',
        leagueTier: 1,
        color: AppColors.silverLeague));

    leagues.add(League(
        svgPath: 'assets/images/gold_trophy.svg',
        name: 'Gold League',
        leagueTier: 2,
        color: AppColors.goldLeague));

    leagues.add(League(
        svgPath: 'assets/images/emerald_trophy.svg',
        name: 'Emerald League',
        leagueTier: 3,
        color: AppColors.emeraldLeague));

    leagues.add(League(
        svgPath: 'assets/images/ruby_trophy.svg',
        name: 'Ruby League',
        leagueTier: 4,
        color: AppColors.rubyLeague));

    leagues.add(League(
        svgPath: 'assets/images/diamond_trophy.svg',
        name: 'Diamond League',
        leagueTier: 5,
        color: AppColors.diamondLeague));

    leagues.sort((a, b) => a.leagueTier.compareTo(b.leagueTier));

    return leagues;
  }

  // Convert Firestore document to League object
  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      color: Color(json['color']),
      name: json['name'] as String,
      leagueTier: json['tier'] as int,
      position: json['position'] as int,
      userId: json['userId'] as String,
    );
  }

  // Convert League object to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'name': name,
      'leagueTier': leagueTier,
      'position': position,
      'userId': userId,
    };
  }
}
