import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/src/features/leaderboard/domain/leagues.dart';
import 'package:drive_safe/src/shared/utils/crypto_utils.dart';
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

  Future<League?> getUserLeague(String leagueId) async {
    DocumentSnapshot<League> userLeagueSnapshot = await _firestore
        .collection('leagues')
        .doc(leagueId)
        .withConverter<League>(
          fromFirestore: (snapshot, _) => League.fromJson(snapshot.data()!),
          toFirestore: (league, _) => league.toJson(),
        )
        .get();

    return userLeagueSnapshot.data();
  }

  Future<void> createUserLeague(String userId) async {
    String leagueId = CryptoUtils.generateRandomId();
    League league = League(
      id: leagueId,
      name: 'bronze',
      tier: 0,
      color: 0xFFe7a461,
      points: 0,
      position: 0,
      userId: userId,
      movement: '',
    );

    await _firestore.collection('leagues').doc(userId).set(
          league as Map<String, dynamic>,
        );
  }
}

@Riverpod(keepAlive: true)
LeaguesRepository leaguesRepository(Ref ref) {
  return LeaguesRepository(FirebaseFirestore.instance);
}
