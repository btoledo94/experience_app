import '../entity/auth_user.dart';
import '../repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<AuthUser?> call({required String email, required String password}) {
    return _repository.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
