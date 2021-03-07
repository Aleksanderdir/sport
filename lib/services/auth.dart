import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:pulse_gym/domain/user.dart' as usr;

class AuthService {
  final fb.FirebaseAuth _fAuth = fb.FirebaseAuth.instance;

  Future<usr.User> signInWithEmailEndPassword(
      String email, String password) async {
    try {
      fb.UserCredential result = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      fb.User user = result.user;
      return usr.User.fromFirebase(user);
    } catch (e) {
      return null;
    }
  }

  Future<usr.User> registerWithEmailEndPassword(
      String email, String password) async {
    try {
      fb.UserCredential result = await _fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      fb.User user = result.user;
      return usr.User.fromFirebase(user);
    } catch (e) {
      return null;
    }
  }

  Future logOut() async {
    await _fAuth.signOut();
  }

  Stream<usr.User> get currentUser {
    return _fAuth.authStateChanges().map(
        (fb.User user) => user != null ? usr.User.fromFirebase(user) : null);
  }
}
