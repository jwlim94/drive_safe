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

  Future<void> signOut() {
    return _authState.signOut();
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) {
    return _authState.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) {
    return _authState.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> deleteUser() async {
    final user = _authState.currentUser;
    if (user == null) return;

    return user.delete();
  }
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
