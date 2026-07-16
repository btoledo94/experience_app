import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_role.dart';

part 'user_profile.freezed.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const UserProfile._();

  const factory UserProfile({
    required AppRole role,
    String? uid,
    String? correo,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json, {String? uid}) {
    return UserProfile(
      uid: uid,
      correo: json['correo'] as String?,
      role: appRoleFromValue(json['rol'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'correo': correo,
      'rol': role.value,
    };
  }
}
