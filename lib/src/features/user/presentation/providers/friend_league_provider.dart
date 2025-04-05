import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/src/features/leaderboard/domain/leagues.dart'; // ✅ 정확한 파일명 반영
import 'package:flutter_riverpod/flutter_riverpod.dart';

final friendLeagueProvider =
    FutureProvider.family<League?, String>((ref, userId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('leagues')
      .where('userId', isEqualTo: userId)
      .get();

  if (snapshot.docs.isEmpty || snapshot.docs.first.data() == null) return null;

  return League.fromMap(snapshot.docs.first.data()); // ✅ fromMap 사용
});
