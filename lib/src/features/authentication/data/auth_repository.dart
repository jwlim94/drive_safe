import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._authState);

  final FirebaseAuth _authState;

  User? get currentUser => _authState.currentUser;

  Stream<User?> authStateChanges() {
    return _authState.authStateChanges();
  }

  // Add signout, send code, and verify code methods here...
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuthState(Ref ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final firebaseAuthState = ref.watch(firebaseAuthStateProvider);
  return AuthRepository(firebaseAuthState);
}
