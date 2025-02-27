import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/src/features/authentication/data/auth_repository.dart';
import 'package:drive_safe/src/features/authentication/domain/auth_user_data.dart';
import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:drive_safe/src/shared/constants/strings.dart';
import 'package:drive_safe/src/shared/utils/color_utils.dart';
import 'package:drive_safe/src/shared/utils/crypto_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_repository.g.dart';

class UsersRepository {
  UsersRepository(this._firestore, this._ref);
  final FirebaseFirestore _firestore;
  final Ref _ref;

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
      code: CryptoUtils.generateRandomUserCode(),
      leagueId: authUserData.leagueId!,
      friends: [],
    );

    await _userDocumentRef(userId).set(user);
    return user;
  }

  Future<void> updateUserFriends(
      String userId, String friendId, String action) async {
    final usersRef = _firestore.collection(Strings.usersCollection).doc(userId);

    if (action == 'add') {
      await usersRef.update({
        'friends': FieldValue.arrayUnion([friendId]),
      });
    } else if (action == 'remove') {
      await usersRef.update({
        'friends': FieldValue.arrayRemove([friendId]),
      });
    }
  }

  Future<User> updateUserName(String userId, String name) async {
    final usersRef = _firestore.collection(Strings.usersCollection).doc(userId);

    // Update the user document in Firestore
    await usersRef.update({'name': name});

    // Fetch the udpated user document
    final updatedSnapshot = await usersRef.get();
    if (!updatedSnapshot.exists) throw Exception('User not found');

    return User.fromMap(updatedSnapshot.data()!);
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

  Future<void> deleteUser(String userId) async {
    // start batch
    final batch = _firestore.batch();

    final usersRef = _firestore.collection(Strings.usersCollection).doc(userId);

    // retrieve associated car id
    final userSnapshot = await usersRef.get();
    final user = User.fromMap(userSnapshot.data()!);
    final carId = user.carId;

    // delete user from collection
    batch.delete(usersRef);

    final carsRef = _firestore.collection(Strings.carsCollection).doc(carId);

    // delete associated car
    batch.delete(carsRef);

    // end batch
    await batch.commit();

    // delete user from Firebase Authentication
    _ref.read(authRepositoryProvider).deleteUser();
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
  return UsersRepository(FirebaseFirestore.instance, ref);
}
