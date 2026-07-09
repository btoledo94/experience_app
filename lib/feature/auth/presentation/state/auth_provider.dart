import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_sources/firebase_auth_data_source.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../domain/entity/auth_user.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/use_cases/get_current_auth_user_use_case.dart';
import '../../domain/use_cases/sign_in_use_case.dart';
import '../../domain/use_cases/sign_out_use_case.dart';
import '../../domain/use_cases/sign_up_use_case.dart';
import '../../domain/use_cases/watch_auth_state_use_case.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthDataSource(firebaseAuth);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

final getCurrentAuthUserUseCaseProvider = Provider<GetCurrentAuthUserUseCase>((
  ref,
) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentAuthUserUseCase(repository);
});

final watchAuthStateUseCaseProvider = Provider<WatchAuthStateUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return WatchAuthStateUseCase(repository);
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInUseCase(repository);
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUpUseCase(repository);
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignOutUseCase(repository);
});

final authStateProvider = StreamProvider<AuthUser?>((ref) {
  final watchAuthState = ref.watch(watchAuthStateUseCaseProvider);
  return watchAuthState();
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final SignUpUseCase _signUpUseCase;
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;

  AuthController(this._signUpUseCase, this._signInUseCase, this._signOutUseCase)
    : super(const AsyncData(null));

  Future<void> signUp({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      await _signUpUseCase(email: email, password: password);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      await _signInUseCase(email: email, password: password);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await _signOutUseCase();
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
      final signUpUseCase = ref.watch(signUpUseCaseProvider);
      final signInUseCase = ref.watch(signInUseCaseProvider);
      final signOutUseCase = ref.watch(signOutUseCaseProvider);
      return AuthController(signUpUseCase, signInUseCase, signOutUseCase);
    });
