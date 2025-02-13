import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/src/features/authentication/domain/auth_user_data.dart';
import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:drive_safe/src/shared/constants/strings.dart';
import 'package:drive_safe/src/shared/utils/color_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_repository.g.dart';

class UsersRepository {
  UsersRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Future<User?> fetchUser(String userId) async {
    final snapshot = await _userDocumentRef(userId).get();
    return snapshot.data();
  }

  Future<User> createUser(AuthUserData authUserData) async {
    final String userId = authUserData.id!;

    final user = User(
      id: userId,
      name: authUserData.name!,
      age: authUserData.age!,
      carId: authUserData.carId!,
      email: authUserData.email!,
      primaryColor: ColorUtils.generateRandomColors()[0],
      secondaryColor: ColorUtils.generateRandomColors()[1],
    );

    await _userDocumentRef(userId).set(user);
    return user;
  }

  Future<User> updateUserColors(
    String userId,
    int primaryColor,
    int secondaryColor,
  ) async {
    final usersRef = _firestore.collection(Strings.usersCollection).doc(userId);

    // Update the user document in Firestore
    await usersRef.update({
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
    });

    // Fetch the udpated user document
    final updatedSnapshot = await usersRef.get();
    if (!updatedSnapshot.exists) throw Exception('User not found');

    return User.fromMap(updatedSnapshot.data()!);
  }

  DocumentReference<User> _userDocumentRef(String userId) {
    return _firestore
        .collection(Strings.usersCollection)
        .doc(userId)
        .withConverter(
          fromFirestore: (doc, _) => User.fromMap(doc.data()!),
          toFirestore: (User user, _) => user.toMap(),
        );
  }
}

@Riverpod(keepAlive: true)
UsersRepository usersRepository(Ref ref) {
  return UsersRepository(FirebaseFirestore.instance);
}
