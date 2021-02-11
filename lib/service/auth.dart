import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:videocall/model/store_user.dart';
import 'package:videocall/model/user.dart';
import 'package:videocall/service/firebase_methods.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin facebookLogin = FacebookLogin();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Users _takeAnParamaterFromUser(User user) {
    return user != null ? Users(uid: user.uid) : null;
  }


  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<User> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<Userlar> getUserDetails() => _firebaseMethods.getUserDetails();



  Future<bool> authenticateUser(User user) =>
      _firebaseMethods.authenticateUser(user);

  Future<void> addDataToDb({User user, String name}) =>
      _firebaseMethods.addDataToDb(user, name: name);
  Future<List<Userlar>> fetchAllUsers(User user) =>
      _firebaseMethods.fetchAllUsers(user);

  Stream<Users> get usert {
    return _auth
        .authStateChanges()
        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_takeAnParamaterFromUser);
  }


  Future signInAnony() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _takeAnParamaterFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailandPassaword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      // Handle err
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future registerWithEmailandPassaword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _takeAnParamaterFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  Future<void> handleLogin() async {
    final FacebookLoginResult result = await facebookLogin.logIn(["email"]);
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
      case FacebookLoginStatus.loggedIn:
        try {
          await loginWithfacebook(result);
        } catch (e) {
          print(e);
        }
        break;
    }
  }

  Future loginWithfacebook(FacebookLoginResult result) async {
    final FacebookAccessToken accessToken = result.accessToken;
    AuthCredential credential =
        FacebookAuthProvider.credential(accessToken.token);
    var a = await _auth.signInWithCredential(credential);
    User user = a.user;
    return _takeAnParamaterFromUser(user);
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;
    return _takeAnParamaterFromUser(user);
  }
  

  Future signOut() async {
    try {
      await _auth.signOut();

    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
