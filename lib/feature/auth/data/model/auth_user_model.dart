import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/auth_user.dart';

part 'auth_user_model.freezed.dart';

@freezed
class AuthUserModel with _$AuthUserModel {
  const AuthUserModel._();

  const factory AuthUserModel({required String uid, String? email}) =
      _AuthUserModel;

  factory AuthUserModel.fromFirebaseUser(User user) {
    return AuthUserModel(uid: user.uid, email: user.email);
  }

  AuthUser toEntity() {
    return AuthUser(uid: uid, email: email);
  }
}
