import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:chatverse_chat_app/utilities/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuthService._();

  static String _loggedInUserId;

  static final FirebaseAuth _auth = FirebaseAuth.instance;

//  static Future<String> getCurrentUser() async {
//    try {
//      final FirebaseUser currentFirebaseUser = await _auth.currentUser();
//      if (currentFirebaseUser != null && currentFirebaseUser.isEmailVerified)
//        _userId = currentFirebaseUser.uid;
//      else
//        _userId = null;
//    } catch (e) {
//      print("ERROR WHILE GETTING CURRENT USER : $e");
//      _userId = null;
//    }
//    return _userId;
//  }

  static Future<String> loginUser(String email, String password) async {
    email = email.trim().toLowerCase();
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        if (user.user.isEmailVerified) {
          _loggedInUserId = user.user.uid;
          return _loggedInUserId;
        } else
          throw SignInException("EMAIL_NOT_VERIFIED");
      } else
        return null;
    } catch (e) {
      print("EXCEPTION WHILE LOGGING IN USER : $e");
      throw SignInException(e.message);
    }
  }

  static Future<bool> registerUser(
      {String email, String password, String name}) async {
    email = email.trim().toLowerCase();
    try {
      final AuthResult user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await user.user.sendEmailVerification();

      if (user != null) {
        await FirebaseStorageService.setInitialUserData(user.user.uid, {
          "name": name,
          "email": email,
          "profilePicURL": "default URL here",
        });
        return true;
      } else
        return false;
    } catch (e) {
      print("EXCEPTION WHILE REGISTERING NEW USER : $e");
      throw SignUpException(e.message);
    }
  }

  static Future<bool> logoutUser() async {
    try {
      _loggedInUserId = null;
      await _auth.signOut();
      return true;
    } catch (e) {
      print("EXCEPTION WHILE LOGGING OUT USER : $e");
      return false;
    }
  }

  static Future<bool> resendEmailVerificationLink(
      String email, String password) async {
    email = email.trim().toLowerCase();
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        await user.user.sendEmailVerification();
        return true;
      } else
        return false;
    } catch (e) {
      print("ERROR WHILE RE SENDING EMAIL VERIFICATION LINK : $e");
      return false;
    }
  }

  static Future<bool> sendPasswordResetEmail(String email) async {
    email = email.trim().toLowerCase();
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print("ERROR WHILE SENDING PASSWORD RESET EMAIL : $e");
      throw ForgotPasswordException(e.message);
    }
  }
}
