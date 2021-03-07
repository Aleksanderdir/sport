import 'package:firebase_auth/firebase_auth.dart' as fb;

class User {
  String id;

  User.fromFirebase(fb.User user) {
    id = user.uid;
  }
}
