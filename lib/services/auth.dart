import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserId {
  UserId(
      {@required this.userEmail,
      @required this.uid,
       this.phone,
      @required this.photoUrl,
      @required this.displayName});

  final String uid;
  final String photoUrl;
  final String phone;
  final String displayName;
  final String userEmail;
}

abstract class AuthBase {
  Stream<UserId> get onAuthStateChanged;

  Future<UserId> currentUser();

  Future<UserId> signInAnonymously();

  Future<UserId> signInWithEmailAndPassword(String email, String password);

  Future<UserId> createUserWithEmailAndPassword(String email, String password);

  Future<UserId> signInWithGoogle();

  Future<String> updateUser(String name, String photo);

  Future<String> updateUserphoto(String photoUrl);

  Future<String> updateUserName(String name);

  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  UserId _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return UserId(
        uid: user.uid,
        phone:user.phoneNumber,
        photoUrl: user.photoURL,
        displayName: user.displayName,
        userEmail: user.email);
  }

  Future<String> updateUser(String name, photo) async {
    final user = _firebaseAuth.currentUser;

    await user.updateProfile(displayName: name);
    await user.updateProfile(photoURL: photo);

    await user.reload();
    return user.uid;
  }

  Future<String> updateUserName(String name) async {
    final user = _firebaseAuth.currentUser;
    await user.updateProfile(displayName: name);
    await user.reload();
    return user.uid;
  }

  Future<String> updateUserEmail(String photoUrl) async {
    final user = _firebaseAuth.currentUser;
    user.updateProfile(photoURL: photoUrl);
    await user.updateProfile();
    await user.reload();
    return user.uid;
  }

  @override
  Future<String> updateUserphoto(String photoUrl) async {
    final user = _firebaseAuth.currentUser;
    user.updateProfile(displayName: photoUrl);
    await user.updateProfile();
    await user.reload();
    return user.uid;
  }

  @override
  Stream<UserId> get onAuthStateChanged {
    // return _firebaseAuth.authStateChanges().map(_userFromFirebase);
    return _firebaseAuth.authStateChanges().map((event) {
      return UserId(
          uid: event.uid,
          userEmail: event.email,
          photoUrl: event.photoURL,
          displayName: event.displayName);
    });
  }

  @override
  Future<UserId> currentUser() async {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<UserId> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserId> signInWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserId> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserId> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
