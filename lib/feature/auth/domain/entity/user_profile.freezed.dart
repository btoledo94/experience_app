// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'user_profile.dart';

mixin _$UserProfile {
  AppRole get role;
  String? get uid;
  String? get correo;
}

class _UserProfile extends UserProfile {
  const _UserProfile({
    required this.role,
    this.uid,
    this.correo,
  }) : super._();

  @override
  final AppRole role;
  @override
  final String? uid;
  @override
  final String? correo;

  @override
  String toString() {
    return 'UserProfile(role: $role, uid: $uid, correo: $correo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is _UserProfile &&
            other.role == role &&
            other.uid == uid &&
            other.correo == correo);
  }

  @override
  int get hashCode => Object.hash(role, uid, correo);
}
