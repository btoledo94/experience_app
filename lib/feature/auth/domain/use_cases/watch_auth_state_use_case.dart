import '../entity/auth_user.dart';
import '../repository/auth_repository.dart';

class WatchAuthStateUseCase {
  final AuthRepository _repository;

  WatchAuthStateUseCase(this._repository);

  Stream<AuthUser?> call() {
    return _repository.authStateChanges();
  }
}
