import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/src/features/authentication/data/auth_repository.dart';
import 'package:drive_safe/src/features/authentication/domain/auth_user_data.dart';
import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:drive_safe/src/shared/constants/enums.dart';
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

  Future<User> createUser(AuthUserData authUserData, AuthType authType) async {
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
      isGuest: authType == AuthType.guest ? true : false,
      drivePoints: 0,
      driveStreak: 0,
      enduranceSeconds: 0, // ✅ 여기 추가!!
      userGoal: 0,
      goalCompleteByTime: 0,
      highestScore: 0,
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

  Future<User> updateUserDriveStreak(String userId, int driveStreak) async {
    final usersRef = _firestore.collection(Strings.usersCollection).doc(userId);

    // Update the user document in Firestore
    await usersRef.update({'driveStreak': driveStreak});

    // Fetch the udpated user document
    final updatedSnapshot = await usersRef.get();
    if (!updatedSnapshot.exists) throw Exception('User not found');

    return User.fromMap(updatedSnapshot.data()!);
  }

  Future<User> updateUserLastDriveStreakAt(String userId, int timestamp) async {
    final usersRef = _firestore.collection(Strings.usersCollection).doc(userId);

    // Update the user document in Firestore
    await usersRef.update({'lastDriveStreakAt': timestamp});

    // Fetch the udpated user document
    final updatedSnapshot = await usersRef.get();
    if (!updatedSnapshot.exists) throw Exception('User not found');

    return User.fromMap(updatedSnapshot.data()!);
  }

  Future<User> updateUserDrivePoints(String userId, int drivePoints) async {
    final usersRef = _firestore.collection(Strings.usersCollection).doc(userId);

    // Update the user document in Firestore
    await usersRef.update({'drivePoints': drivePoints});

    // Fetch the udpated user document
    final updatedSnapshot = await usersRef.get();
    if (!updatedSnapshot.exists) throw Exception('User not found');

    return User.fromMap(updatedSnapshot.data()!);
  }

  Future<User> updateUserEmail(String userId, String email) async {
    final usersRef = _firestore.collection(Strings.usersCollection).doc(userId);

    // Update the user document in Firestore
    await usersRef.update({'email': email});

    // Fetch the udpated user document
    final updatedSnapshot = await usersRef.get();
    if (!updatedSnapshot.exists) throw Exception('User not found');

    return User.fromMap(updatedSnapshot.data()!);
  }

  Future<User> updateUserIsGuest(String userId, bool isGuest) async {
    final usersRef = _firestore.collection(Strings.usersCollection).doc(userId);

    // Update the user document in Firestore
    await usersRef.update({'isGuest': isGuest});

    // Fetch the udpated user document
    final updatedSnapshot = await usersRef.get();
    if (!updatedSnapshot.exists) throw Exception('User not found');

    return User.fromMap(updatedSnapshot.data()!);
  }

  Future<User> updateUserEnduranceMinutes(
      String userId, int enduranceSeconds) async {
    final usersRef = _firestore.collection(Strings.usersCollection).doc(userId);

    await usersRef.update({'enduranceSeconds': enduranceSeconds});

    final updatedSnapshot = await usersRef.get();
    if (!updatedSnapshot.exists) throw Exception('User not found');

    return User.fromMap(updatedSnapshot.data()!);
  }

  Future<User> updateUserBadges(String userId, List<String> badges) async {
    final usersRef = _firestore.collection(Strings.usersCollection).doc(userId);
    await usersRef.update({'badges': badges});

    final updatedSnapshot = await usersRef.get();
    if (!updatedSnapshot.exists) throw Exception('User not found');

    return User.fromMap(updatedSnapshot.data()!);
  }

  Future<User> updateUserHighestScore(String userId, int highestScore) async {
    final usersRef = _firestore.collection(Strings.usersCollection).doc(userId);
    await usersRef.update({'highestScore': highestScore});

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

  Future<void> updateUserDailyGoal(int dailyGoalTime, String userId) async {
    final usersRef = _firestore.collection(Strings.usersCollection).doc(userId);

    await usersRef.update({'userGoal': dailyGoalTime});
  }

  Future<void> updateGoalCompleteTime(String userId, int oneDayFromNow) async {
    final usersRef = _firestore.collection(Strings.usersCollection).doc(userId);

    await usersRef.update({'goalCompleteByTime': oneDayFromNow});
  }

  Future<void> resetGoalCompleteTime(String userId) async {
    const int resetGoalCompleteTime = 0;
    final usersRef = _firestore.collection(Strings.usersCollection).doc(userId);

    await usersRef.update({'goalCompleteByTime': resetGoalCompleteTime});
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
