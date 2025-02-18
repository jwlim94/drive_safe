import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';

class League {
  String svgPath;
  int lowBound;
  int highBound;
  String name;
  int leagueTier;
  Color color;
  int position;
  String userId;
  String movement;
  int points;
  String id;

  League({
    this.svgPath = '',
    required this.name,
    required this.leagueTier,
    required this.color,
    this.position = 0,
    this.userId = '',
    this.highBound = 0, //exclusive
    this.lowBound = 0, //inclusive
    this.movement = 'none',
    this.points = 0,
    this.id = '',
  });
  static List<League> getLeagues() {
    List<League> leagues = [];

    leagues.add(League(
      svgPath: 'assets/images/bronze_trophy.svg',
      name: 'Bronze League',
      leagueTier: 0,
      color: AppColors.bronzeLeague,
      lowBound: 0,
      highBound: 500,
    ));

    leagues.add(League(
      svgPath: 'assets/images/silver_trophy.svg',
      name: 'Silver League',
      leagueTier: 1,
      color: AppColors.silverLeague,
      lowBound: 500,
      highBound: 1000,
    ));

    leagues.add(League(
      svgPath: 'assets/images/gold_trophy.svg',
      name: 'Gold League',
      leagueTier: 2,
      color: AppColors.goldLeague,
      lowBound: 1000,
      highBound: 2000,
    ));

    leagues.add(League(
      svgPath: 'assets/images/emerald_trophy.svg',
      name: 'Emerald League',
      leagueTier: 3,
      color: AppColors.emeraldLeague,
      lowBound: 2000,
      highBound: 4000,
    ));

    leagues.add(League(
      svgPath: 'assets/images/ruby_trophy.svg',
      name: 'Ruby League',
      leagueTier: 4,
      color: AppColors.rubyLeague,
      lowBound: 4000,
      highBound: 8000,
    ));

    leagues.add(League(
      svgPath: 'assets/images/diamond_trophy.svg',
      name: 'Diamond League',
      leagueTier: 5,
      color: AppColors.diamondLeague,
      lowBound: 8000,
    ));

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
      movement: json['movement'] as String,
      points: json['points'] as int,
      id: json['id'] as String,
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
      'movement': movement,
      'points': points,
      'id': id,
    };
  }
}
