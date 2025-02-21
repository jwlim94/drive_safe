import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/src/features/leaderboard/domain/leagues.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'leagues_repository.g.dart';

class LeaguesRepository {
  LeaguesRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Future<List<Map<String, dynamic>>> getSelectedLeague(selectedLeague) async {
    QuerySnapshot<League> leagueSnapshot = await _firestore
        .collection('leagues')
        .withConverter<League>(
          fromFirestore: (snapshot, _) => League.fromJson(snapshot.data()!),
          toFirestore: (league, _) => league.toJson(),
        )
        .where('tier', isEqualTo: selectedLeague)
        .get();

    List<League> leagueInfo =
        leagueSnapshot.docs.map((doc) => doc.data()).toList();

    List<String> userIds =
        leagueInfo.map((league) => league.userId).toSet().toList();

    if (userIds.isEmpty) return [];

    QuerySnapshot<Map<String, dynamic>> userSnapshot = await _firestore
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds)
        .get();

    Map<String, Map<String, dynamic>> userMap = {
      for (var doc in userSnapshot.docs) doc.id: doc.data(),
    };

    List<Map<String, dynamic>> userLeageSnapshot = leagueInfo.map((league) {
      return {
        'league': league,
        'user': userMap[league.userId] ?? {},
      };
    }).toList();

    userLeageSnapshot.sort((a, b) {
      int aPoints = a["league"].points ?? 0;
      int bPoints = b["league"].points ?? 0;

      return bPoints.compareTo(aPoints);
    });

    return userLeageSnapshot;
  }

  void updateMovementPositions(List<Map<String, dynamic>> leagueData) async {
    for (var item in leagueData) {
      var leagueId = item['user']['leagueId'];
      var movement = item['movement'];
      var newPosition = item['position'];

      await _firestore.collection('leagues').doc(leagueId).update({
        'position': newPosition,
        'movement': movement,
      });
    }
  }

  void updateUserLeagueInfo(String userId, String leagueId,
      List<League> leagues, int lastDrivePoints) async {
    QuerySnapshot<League> userLeagueSnapshot = await _firestore
        .collection('leagues')
        .withConverter<League>(
          fromFirestore: (snapshot, _) => League.fromJson(snapshot.data()!),
          toFirestore: (league, _) => league.toJson(),
        )
        .where('id', isEqualTo: leagueId)
        .get();

    final currentUserLeague =
        userLeagueSnapshot.docs.map((doc) => doc.data()).toList().first;
    final newPoints = currentUserLeague.points + lastDrivePoints;
    String newLeague = '';
    String oldLeague = currentUserLeague.name;
    int newLeagueColor = currentUserLeague.color;
    String newMovement = '';
    int newTier = currentUserLeague.leagueTier;

    for (League league in leagues) {
      if (newPoints >= league.lowBound && newPoints < league.highBound) {
        newLeague = league.name;
        if (newLeague != oldLeague) {
          newMovement = 'increased';
          newLeagueColor = league.color;
          newTier = league.leagueTier;
        }
      } else if (newPoints >= league.lowBound && league.highBound.isNaN) {
        newLeague = league.name;
      }
    }

    await _firestore.collection('leagues').doc(leagueId).update({
      'points': newPoints,
      'name': newLeague,
      'color': newLeagueColor,
      'movement': newMovement,
      'tier': newTier,
    });
  }
}

@Riverpod(keepAlive: true)
LeaguesRepository leaguesRepository(Ref ref) {
  return LeaguesRepository(FirebaseFirestore.instance);
}
