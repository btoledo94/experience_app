import '../entity/auth_user.dart';
import '../entity/user_profile.dart';

abstract class AuthRepository {
  AuthUser? get currentUser;

  Stream<AuthUser?> authStateChanges();

  Stream<UserProfile?> watchCurrentUserProfile();

  Future<UserProfile?> getCurrentUserProfile();

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
