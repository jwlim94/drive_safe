class League {
  String svgPath;
  int lowBound;
  int highBound;
  String name;
  int tier;
  int color;
  int position;
  String userId;
  String movement;
  int points;
  String id;

  League({
    this.svgPath = '',
    required this.name,
    required this.tier,
    required this.color,
    this.position = 0,
    this.userId = '',
    this.highBound = 0, //exclusive
    this.lowBound = 0, //inclusive
    this.movement = 'none',
    this.points = 0,
    required this.id,
  });
  static List<League> getLeagues() {
    List<League> leagues = [];

    leagues.add(League(
      svgPath: 'assets/images/bronze_trophy.svg',
      name: 'Bronze League',
      tier: 0,
      color: 0xFFe7a461,
      lowBound: 0,
      highBound: 500,
      id: '',
    ));

    leagues.add(League(
      svgPath: 'assets/images/silver_trophy.svg',
      name: 'Silver League',
      tier: 1,
      color: 0xFFc0c0c0,
      lowBound: 500,
      highBound: 1000,
      id: '',
    ));

    leagues.add(League(
      svgPath: 'assets/images/gold_trophy.svg',
      name: 'Gold League',
      tier: 2,
      color: 0xFFc5be44,
      lowBound: 1000,
      highBound: 2000,
      id: '',
    ));

    leagues.add(League(
      svgPath: 'assets/images/emerald_trophy.svg',
      name: 'Emerald League',
      tier: 3,
      color: 0xFF448f60,
      lowBound: 2000,
      highBound: 4000,
      id: '',
    ));

    leagues.add(League(
      svgPath: 'assets/images/ruby_trophy.svg',
      name: 'Ruby League',
      tier: 4,
      color: 0xFFba4588,
      lowBound: 4000,
      highBound: 8000,
      id: '',
    ));

    leagues.add(League(
      svgPath: 'assets/images/diamond_trophy.svg',
      name: 'Diamond League',
      tier: 5,
      color: 0xFF1a857f,
      lowBound: 8000,
      id: '',
    ));

    leagues.sort((a, b) => a.tier.compareTo(b.tier));

    return leagues;
  }

  // Convert Firestore document to League object
  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      color: json['color'] as int,
      name: json['name'] as String,
      tier: json['tier'] as int,
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
      'tier': tier,
      'position': position,
      'userId': userId,
      'movement': movement,
      'points': points,
      'id': id,
    };
  }
}
