import 'package:drive_safe/src/features/leaderboard/application/league_points_service.dart';
import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_user_league_status_controller.g.dart';

@riverpod
class UpdateUserLeagueStatusController
    extends _$UpdateUserLeagueStatusController {
  @override
  void build(User currentUser, int lastDrivePoints) async {
    final leaguePointsService = ref.read(leaguePointsServiceProvider);
    final userId = currentUser.id;
    final leagueId = currentUser.leagueId;

    final updateLeagueInformation = leaguePointsService.updateUserLeagueInfo(
        userId, leagueId, lastDrivePoints);

    return updateLeagueInformation;
  }
}
