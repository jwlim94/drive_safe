import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final friendUserProvider =
    FutureProvider.family<User?, String>((ref, userId) async {
  try {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (!doc.exists || doc.data() == null) {
      print('User not found: $userId');
      return null;
    }
    print('User found: ${doc.data()}');
    return User.fromMap(doc.data()!);
  } catch (e) {
    print('friendUserProvider error: $e');
    rethrow;
  }
});
