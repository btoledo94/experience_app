import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/auth_user.dart';

class AuthUserModel {
  final String uid;
  final String? email;

  const AuthUserModel({required this.uid, this.email});

  factory AuthUserModel.fromFirebaseUser(User user) {
    return AuthUserModel(uid: user.uid, email: user.email);
  }

  AuthUser toEntity() {
    return AuthUser(uid: uid, email: email);
  }
}
