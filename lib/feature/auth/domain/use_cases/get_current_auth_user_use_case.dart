import '../entity/auth_user.dart';
import '../repository/auth_repository.dart';

class GetCurrentAuthUserUseCase {
  final AuthRepository _repository;

  GetCurrentAuthUserUseCase(this._repository);

  AuthUser? call() {
    return _repository.currentUser;
  }
}
