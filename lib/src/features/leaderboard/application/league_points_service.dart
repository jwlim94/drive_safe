import 'package:drive_safe/src/features/leaderboard/data/leagues_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'league_points_service.g.dart';

class LeaguePointsService {
  const LeaguePointsService(this.ref, this.leaguesRepository);
  final Ref ref;
  final LeaguesRepository leaguesRepository;

  List<Map<String, dynamic>> leaguePlacement(
      List<Map<String, dynamic>> leagueData) {
    int position = 1;
    int priorPosition = 0;
    for (int i = 0; i < leagueData.length; i++) {
      priorPosition = leagueData[i]["league"].position;
      if (i > 0 &&
          leagueData[i]["league"].points ==
              leagueData[i - 1]["league"].points) {
        leagueData[i]['position'] = leagueData[i - 1]['position'];
      } else {
        leagueData[i]['position'] = position;
      }

      if (priorPosition == position) {
        leagueData[i]['movement'] = '';
      } else if (priorPosition < position) {
        leagueData[i]['movement'] = 'decreased';
      } else {
        leagueData[i]['movement'] = 'increased';
      }

      position++;
    }

    leaguesRepository.updateMovementPositions(leagueData);

    return leagueData;
  }
}

@riverpod
LeaguePointsService leaguePointsService(Ref ref) {
  return LeaguePointsService(ref, leaguesRepository(ref));
}
