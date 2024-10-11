import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raporti_veturave_app/models/user.dart';

class UserNotifier extends StateNotifier<AsyncValue<Users?>> {
  UserNotifier() : super(const AsyncValue.loading()) {
    _initializeAuthStateListener();
  }

  void _initializeAuthStateListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        state = const AsyncValue.data(null); // User is signed out
      }
    });
  }

  Future<void> _loadUserData(String userId) async {
    try {
      state = const AsyncValue.loading();
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        state = AsyncValue.data(Users(
          id: userId,
          name: userDoc['name'],
          email: userDoc['email'],
        ));
      } else {
        throw Exception('User document does not exist');
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Sign Up Method
  Future<void> signUp(String email, String password, String name) async {
    try {
      state = const AsyncValue.loading();
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'name': name, 'email': email});

      await _loadUserData(userCredential.user!.uid);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Login Method
  Future<void> login(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _loadUserData(userCredential.user!.uid);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Logout Method
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    state = const AsyncValue.data(null);
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<Users?>>((ref) {
  return UserNotifier();
});
