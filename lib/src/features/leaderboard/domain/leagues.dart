import 'package:json_annotation/json_annotation.dart';

part 'leagues.g.dart';

@JsonSerializable()
class League {
  String id;
  String name;
  String displayName;
  int tier;
  int color;
  int position;
  String userId;
  String movement;
  String svgPath;
  int lowBound;
  int highBound;
  int points;

  League({
    required this.id,
    required this.name,
    required this.tier,
    required this.color,
    required this.userId,
    this.svgPath = '',
    this.displayName = '',
    this.position = 0,
    this.highBound = 0, //exclusive
    this.lowBound = 0, //inclusive
    this.points = 0,
    this.movement = 'none',
  });

  factory League.fromJson(Map<String, dynamic> json) => _$LeagueFromJson(json);

  Map<String, dynamic> toJson() => _$LeagueToJson(this);

  factory League.fromMap(Map<String, dynamic> map) {
    return League(
      id: map['id'] as String,
      name: map['name'] as String,
      tier: map['tier'] as int,
      color: map['color'] as int,
      userId: map['userId'] as String,
      position: map['position'] as int,
      highBound: map['highBound'] as int,
      lowBound: map['lowBound'] as int,
      points: map['points'] as int,
      movement: map['movement'] as String,
      svgPath: map['svgPath'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      // Required fields
      'id': id,
      'name': name,
      'tier': tier,
      'color': color,
      'userId': userId,
      'position': position,
      'highBound': highBound,
      'lowBound': lowBound,
      'points': points,
      'movement': movement,
      'svgPath': svgPath,
    };

    return data;
  }

  static List<League> getLeagues() {
    List<League> leagues = [];

    leagues.add(League(
      name: 'bronze',
      svgPath: 'assets/images/bronze_trophy.svg',
      displayName: 'Bronze League',
      tier: 0,
      color: 0xFFe7a461,
      lowBound: 0,
      highBound: 500,
      id: '',
      userId: '',
    ));

    leagues.add(League(
      name: 'silver',
      svgPath: 'assets/images/silver_trophy.svg',
      displayName: 'Silver League',
      tier: 1,
      color: 0xFFc0c0c0,
      lowBound: 500,
      highBound: 1000,
      id: '',
      userId: '',
    ));

    leagues.add(League(
      name: 'gold',
      svgPath: 'assets/images/gold_trophy.svg',
      displayName: 'Gold League',
      tier: 2,
      color: 0xFFc5be44,
      lowBound: 1000,
      highBound: 2000,
      id: '',
      userId: '',
    ));

    leagues.add(League(
      name: 'emerald',
      svgPath: 'assets/images/emerald_trophy.svg',
      displayName: 'Emerald League',
      tier: 3,
      color: 0xFF448f60,
      lowBound: 2000,
      highBound: 4000,
      id: '',
      userId: '',
    ));

    leagues.add(League(
      name: 'ruby',
      svgPath: 'assets/images/ruby_trophy.svg',
      displayName: 'Ruby League',
      tier: 4,
      color: 0xFFba4588,
      lowBound: 4000,
      highBound: 8000,
      id: '',
      userId: '',
    ));

    leagues.add(League(
      name: 'diamond',
      svgPath: 'assets/images/diamond_trophy.svg',
      displayName: 'Diamond League',
      tier: 5,
      color: 0xFF1a857f,
      lowBound: 8000,
      id: '',
      userId: '',
    ));

    leagues.sort((a, b) => a.tier.compareTo(b.tier));

    return leagues;
  }
}
