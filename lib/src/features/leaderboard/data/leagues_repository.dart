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
}

@Riverpod(keepAlive: true)
LeaguesRepository leaguesRepository(Ref ref) {
  return LeaguesRepository(FirebaseFirestore.instance);
}
