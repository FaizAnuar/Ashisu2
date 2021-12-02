import 'package:gowallpaper/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gowallpaper/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on FirebasedUseer
  UserId _userFromFirebaseUser(User user) {
    return user != null ? UserId(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<UserId> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User userFirebase = result.user;
      return _userFromFirebaseUser(userFirebase);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(
      String email, String password, String userName,int userType) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User userFirebase = result.user;
      await userSetup(userName, email,userType);
      return _userFromFirebaseUser(userFirebase);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      _userFromFirebaseUser(null);
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
