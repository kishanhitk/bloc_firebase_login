import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import 'models/models.dart';

class SignUpFailure implements Exception {}

class LoginWithEmailAndPasswordFailure implements Exception {}

class LoginWithGoogleFailure implements Exception {}

class LogoutFailure implements Exception {}

class AuthenticationRepository {
  AuthenticationRepository({
    FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  Stream<User> get user {
    return _firebaseAuth.onAuthStateChanged.map((firebaseUser) {
      return firebaseUser == null ? User.empty : firebaseUser.toUser;
    });
  }

  Future<void> signUp({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception {
      throw SignUpFailure();
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on Exception {
      throw LoginWithGoogleFailure();
    }
  }

  Future<void> logInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on Exception {
      throw LoginWithEmailAndPasswordFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } on Exception {
      throw LogoutFailure();
    }
  }
}

extension on FirebaseUser {
  User get toUser {
    return User(
      id: uid,
      email: email,
      name: displayName,
      photo: photoUrl,
    );
  }
}
