import 'package:drive_safe/src/features/authentication/data/auth_repository.dart';
import 'package:drive_safe/src/features/authentication/presentation/providers/auth_type_state_provider.dart';
import 'package:drive_safe/src/features/car/presentation/controllers/cache_current_car_controller.dart';
import 'package:drive_safe/src/features/leaderboard/data/leagues_repository.dart';
import 'package:drive_safe/src/features/leaderboard/presentation/controllers/cache_current_league_controller.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/cache_current_user_controller.dart';
import 'package:drive_safe/src/features/authentication/presentation/providers/auth_user_data_state_provider.dart';
import 'package:drive_safe/src/features/car/data/cars_repository.dart';
import 'package:drive_safe/src/features/car/presentation/providers/car_data_state_provider.dart';
import 'package:drive_safe/src/features/user/data/users_repository.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

class AuthService {
  const AuthService(this.ref);
  final Ref ref;

  Future<void> signUp() async {
    try {
      // Get user email and password from provider
      final authUserData = ref.read(authUserDataStateProvider);
      final String email = authUserData.email!;
      final String password = authUserData.password!;

      // Create user in Firebase Authentication
      final UserCredential userCredential =
          await ref.read(authRepositoryProvider).createUserWithEmailAndPassword(
                email,
                password,
              );

      // Set Firestore user_id to Firebase Auth user_id
      final String userId = userCredential.user?.uid ?? '';
      if (userId.isEmpty) throw Exception("User Id is missing");
      ref.read(authUserDataStateProvider.notifier).setId(userId);

      // Create a user
      final authType = ref.read(authTypeStateProvider);
      final updatedAuthUserData = ref.read(authUserDataStateProvider);
      final usersRepository = ref.read(usersRepositoryProvider);
      await usersRepository.createUser(updatedAuthUserData, authType);

      // Create a car
      final carData = ref.read(carDataStateProvider);
      final carsRepository = ref.read(carsRepositoryProvider);
      await carsRepository.createCar(carData);

      // Create a league
      final leaguesRepository = ref.read(leaguesRepositoryProvider);
      await leaguesRepository.createUserLeague(userId, authUserData.leagueId!);

      // Caching
      await ref
          .read(cacheCurrentUserControllerProvider.notifier)
          .cacheCurrentUser();
      await ref
          .read(cacheCurrentCarControllerProvider.notifier)
          .cacheCurrentCar();
      await ref
          .read(cacheCurrentLeagueControllerProvider.notifier)
          .cacheCurrentLeague();
    } catch (e) {
      // TODO: Handle rollback
    }
  }

  Future<void> signIn() async {
    try {
      // Get user email and password from provider
      final authUserData = ref.read(authUserDataStateProvider);
      final String email = authUserData.email!;
      final String password = authUserData.password!;

      // Sign in
      await ref.read(authRepositoryProvider).signInWithEmailAndPassword(
            email,
            password,
          );

      // Caching
      await ref
          .read(cacheCurrentUserControllerProvider.notifier)
          .cacheCurrentUser();
      await ref
          .read(cacheCurrentCarControllerProvider.notifier)
          .cacheCurrentCar();
      await ref
          .read(cacheCurrentLeagueControllerProvider.notifier)
          .cacheCurrentLeague();
    } catch (e) {
      // TODO: Handle rollback
    }
  }

  Future<void> signInAnonymously() async {
    try {
      // Get guest user data from provider
      final authUserData = ref.read(authUserDataStateProvider);

      // Sign in anonymously in Firebase Authentication
      final UserCredential userCredential =
          await ref.read(authRepositoryProvider).signInAnonymously();

      final String userId = userCredential.user?.uid ?? '';
      if (userId.isEmpty) throw Exception("User Id is missing");
      ref.read(authUserDataStateProvider.notifier).setId(userId);
      ref.read(authUserDataStateProvider.notifier).setEmail('');

      // Create guest user
      final authType = ref.read(authTypeStateProvider);
      final updatedAuthUserData = ref.read(authUserDataStateProvider);
      await ref.read(usersRepositoryProvider).createUser(
            updatedAuthUserData,
            authType,
          );

      // Create a car
      final carData = ref.read(carDataStateProvider);
      await ref.read(carsRepositoryProvider).createCar(carData);

      // Create a league
      await ref
          .read(leaguesRepositoryProvider)
          .createUserLeague(userId, authUserData.leagueId!);

      // Caching
      await ref
          .read(cacheCurrentUserControllerProvider.notifier)
          .cacheCurrentUser();
      await ref
          .read(cacheCurrentCarControllerProvider.notifier)
          .cacheCurrentCar();
      await ref
          .read(cacheCurrentLeagueControllerProvider.notifier)
          .cacheCurrentLeague();
    } catch (e) {
      // TODO: Handle rollback
    }
  }

  Future<void> anonymousToEmailPassword(String email, String password) async {
    try {
      final User? user = ref.read(authRepositoryProvider).currentUser;
      if (user == null || !user.isAnonymous) {
        throw Exception("User is not a guest");
      }

      final AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);

      await user.linkWithCredential(credential);

      // Update Firestore to mark user as registered
      final usersRepository = ref.read(usersRepositoryProvider);
      final emailUpdatedUser =
          await usersRepository.updateUserEmail(user.uid, email);
      ref.read(currentUserStateProvider.notifier).setUser(emailUpdatedUser);

      final isGuestUpdatedUser =
          await usersRepository.updateUserIsGuest(user.uid, false);
      ref.read(currentUserStateProvider.notifier).setUser(isGuestUpdatedUser);
    } catch (e) {
      // TODO: Handle rollback
    }
  }
}

@riverpod
AuthService authService(Ref ref) {
  return AuthService(ref);
}
