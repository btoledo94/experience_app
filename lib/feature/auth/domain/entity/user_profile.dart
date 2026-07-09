import 'app_role.dart';

class UserProfile {
  final String? uid;
  final String? correo;
  final AppRole role;

  const UserProfile({
    required this.role,
    this.uid,
    this.correo,
  });

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
