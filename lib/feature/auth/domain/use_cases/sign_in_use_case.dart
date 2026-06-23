import '../entity/auth_user.dart';
import '../repository/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<AuthUser?> call({required String email, required String password}) {
    return _repository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
