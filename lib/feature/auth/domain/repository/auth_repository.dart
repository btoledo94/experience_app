import '../entity/auth_user.dart';

abstract class AuthRepository {
  AuthUser? get currentUser;

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
