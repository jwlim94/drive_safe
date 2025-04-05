import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/src/features/car/domain/car.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final friendCarProvider =
    FutureProvider.family<Car?, String>((ref, userId) async {
  final doc =
      await FirebaseFirestore.instance.collection('cars').doc(userId).get();
  if (!doc.exists || doc.data() == null) return null;

  return Car.fromMap(doc.data()!); // ✅ fromMap 사용
});
