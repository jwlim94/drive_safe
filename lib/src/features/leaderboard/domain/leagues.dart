class League {
  String svgPath;
  int lowBound;
  int highBound;
  String name;
  int leagueTier;
  int color;
  String displayName;
  int position;
  String userId;
  String movement;
  int points;
  String id;

  League({
    required this.name,
    required this.leagueTier,
    required this.color,
    this.svgPath = '',
    this.displayName = '',
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
      name: 'bronze',
      svgPath: 'assets/images/bronze_trophy.svg',
      displayName: 'Bronze League',
      leagueTier: 0,
      color: 0xFFe7a461,
      lowBound: 0,
      highBound: 500,
    ));

    leagues.add(League(
      name: 'silver',
      svgPath: 'assets/images/silver_trophy.svg',
      displayName: 'Silver League',
      leagueTier: 1,
      color: 0xFFc0c0c0,
      lowBound: 500,
      highBound: 1000,
    ));

    leagues.add(League(
      name: 'gold',
      svgPath: 'assets/images/gold_trophy.svg',
      displayName: 'Gold League',
      leagueTier: 2,
      color: 0xFFc5be44,
      lowBound: 1000,
      highBound: 2000,
    ));

    leagues.add(League(
      name: 'emerald',
      svgPath: 'assets/images/emerald_trophy.svg',
      displayName: 'Emerald League',
      leagueTier: 3,
      color: 0xFF448f60,
      lowBound: 2000,
      highBound: 4000,
    ));

    leagues.add(League(
      name: 'ruby',
      svgPath: 'assets/images/ruby_trophy.svg',
      displayName: 'Ruby League',
      leagueTier: 4,
      color: 0xFFba4588,
      lowBound: 4000,
      highBound: 8000,
    ));

    leagues.add(League(
      name: 'diamond',
      svgPath: 'assets/images/diamond_trophy.svg',
      displayName: 'Diamond League',
      leagueTier: 5,
      color: 0xFF1a857f,
      lowBound: 8000,
    ));

    leagues.sort((a, b) => a.leagueTier.compareTo(b.leagueTier));

    return leagues;
  }

  // Convert Firestore document to League object
  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      color: json['color'] as int,
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
