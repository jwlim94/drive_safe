import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';

class League {
  String svgPath;
  String name;
  int leaguePosition;
  Color color;

  League({
    required this.svgPath,
    required this.name,
    required this.leaguePosition,
    required this.color,
  });
  static List<League> getLeagues() {
    List<League> leagues = [];

    leagues.add(League(
        svgPath: 'assets/images/bronze_trophy.svg',
        name: 'Bronze League',
        leaguePosition: 0,
        color: AppColors.bronzeLeague));

    leagues.add(League(
        svgPath: 'assets/images/silver_trophy.svg',
        name: 'Silver League',
        leaguePosition: 1,
        color: AppColors.silverLeague));

    leagues.add(League(
        svgPath: 'assets/images/gold_trophy.svg',
        name: 'Gold League',
        leaguePosition: 2,
        color: AppColors.goldLeague));

    leagues.add(League(
        svgPath: 'assets/images/emerald_trophy.svg',
        name: 'Emerald League',
        leaguePosition: 3,
        color: AppColors.emeraldLeague));

    leagues.add(League(
        svgPath: 'assets/images/ruby_trophy.svg',
        name: 'Ruby League',
        leaguePosition: 4,
        color: AppColors.rubyLeague));

    leagues.add(League(
        svgPath: 'assets/images/diamond_trophy.svg',
        name: 'Diamond League',
        leaguePosition: 5,
        color: AppColors.diamondLeague));

    leagues.sort((a, b) => a.leaguePosition.compareTo(b.leaguePosition));

    return leagues;
  }
}
