import 'package:drive_safe/src/features/leaderboard/domain/leagues.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_league_provider.g.dart';

@riverpod
class UserLeagueNotifier extends _$UserLeagueNotifier {
  //initial value
  @override
  League build() {
    return League(
      svgPath: 'assets/images/bronze_trophy.svg',
      displayName: 'Bronze League',
      name: 'bronze',
      tier: 0,
      color: 0xFFe7A461,
      id: '',
      userId: '',
    );
  }
}
