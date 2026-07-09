import '../../domain/entity/auth_user.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_sources/firebase_auth_data_source.dart';
import '../model/auth_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  AuthUser? get currentUser {
    final user = _dataSource.currentUser;
    if (user == null) return null;
    return AuthUserModel.fromFirebaseUser(user).toEntity();
  }

  @override
  Stream<AuthUser?> authStateChanges() {
    return _dataSource.authStateChanges().map((user) {
      if (user == null) return null;
      return AuthUserModel.fromFirebaseUser(user).toEntity();
    });
  }

  @override
  Future<AuthUser?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final user = await _dataSource.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (user == null) return null;

    return AuthUserModel.fromFirebaseUser(user).toEntity();
  }

  @override
  Future<AuthUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final user = await _dataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (user == null) return null;

    return AuthUserModel.fromFirebaseUser(user).toEntity();
  }

  @override
  Future<void> signOut() => _dataSource.signOut();
}
