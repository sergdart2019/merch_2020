import 'package:firebase_auth/firebase_auth.dart';

import '../model_user/model_user.dart';

class ServiceAuthenticate {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Create User object based on FirebaseUser
  User _userFromFirebaseUser({FirebaseUser user, String email}) {
    return user != null ? User(uid: user.uid, email: user.email) : null;
  }

  /// Auth change user stream, returns FirebaseUser, but maps it to User
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((user) => _userFromFirebaseUser(user: user));
  }

  /// Sign in email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser user = result.user;
      String userEmail = user.email;
      return _userFromFirebaseUser(user: user, email: userEmail);
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}

/*
  /// Sign in anonymously
  Future singInAnonymously() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
 */

/*
  /// Register email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser user = result.user;

//      /// Creates new document with dummy data
//      await ServiceDatabase(uid: user.uid).updateUserData(
//        'new member',
//        '0',
//        100,
//      );
      return _userFromFirebaseUser(user: user);
    } catch (e) {
      print(e);
      return null;
    }
  }
*/