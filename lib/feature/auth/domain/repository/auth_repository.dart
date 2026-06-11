import '../entity/auth_user.dart';

abstract class AuthRepository {
  Stream<AuthUser?> authStateChanges();

  Future<AuthUser?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
