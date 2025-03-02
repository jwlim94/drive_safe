import 'package:drive_safe/src/features/leaderboard/domain/leagues.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_league_state_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentLeagueState extends _$CurrentLeagueState {
  @override
  League? build() {
    return null;
  }

  void setLeague(League league) {
    state = league;
  }

  void clearLeague() {
    state = null;
  }
}
