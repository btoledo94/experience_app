import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/app_role.dart';
import '../../domain/entity/user_profile.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDataSource(this._firebaseAuth, this._firestore);

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  Stream<UserProfile?> watchCurrentUserProfile() {
    final user = currentUser;
    if (user == null) return Stream.value(null);

    final email = user.email?.trim();
    if (email == null || email.isEmpty) return Stream.value(null);

    return _firestore
        .collection('usuario_perfil')
        .doc(email)
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        return UserProfile(uid: user.uid, correo: email, role: AppRole.buyer);
      }

      return UserProfile.fromJson(doc.data() ?? {}, uid: user.uid);
    });
  }

  Future<UserProfile?> getCurrentUserProfile() async {
    final user = currentUser;
    if (user == null) return null;

    final email = user.email?.trim();
    if (email == null || email.isEmpty) return null;

    final doc = await _firestore.collection('usuario_perfil').doc(email).get();
    if (!doc.exists) {
      return UserProfile(uid: user.uid, correo: email, role: AppRole.buyer);
    }

    return UserProfile.fromJson(doc.data() ?? {}, uid: user.uid);
  }

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  Future<void> signOut() => _firebaseAuth.signOut();
}
