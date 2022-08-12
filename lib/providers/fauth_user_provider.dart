import 'package:firebase_auth/firebase_auth.dart';

class FAuthUserProvider {
  final _fAuth = FirebaseAuth.instance;
  Future<User?> signUp(String email, String password) async {
    final credentials = await _fAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return credentials.user;
  }

  Future<User> signIn(String email, String password) async {
    final credentials = await _fAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return credentials.user!;
  }

  Future<void> signOut() async {
    return _fAuth.signOut();
  }

  User? get currentUser => _fAuth.currentUser;
}
