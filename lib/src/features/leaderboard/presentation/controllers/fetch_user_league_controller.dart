import 'package:drive_safe/src/features/leaderboard/application/league_points_service.dart';
import 'package:drive_safe/src/features/leaderboard/data/leagues_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_user_league_controller.g.dart';

@riverpod
class FetchUserLeagueController extends _$FetchUserLeagueController {
  @override
  FutureOr<List<Map<String, dynamic>>> build(int selectedLeague) async {
    final leaguePointsService = ref.read(leaguePointsServiceProvider);

    final leagueInfo = await ref
        .read(leaguesRepositoryProvider)
        .getSelectedLeague(selectedLeague);

    final processedLeagueInfo = leaguePointsService.leaguePlacement(leagueInfo);

    return processedLeagueInfo;
  }
}
