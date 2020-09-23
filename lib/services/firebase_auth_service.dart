import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:chatverse_chat_app/utilities/constants.dart';
import 'package:chatverse_chat_app/utilities/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User get currentUser => _auth.currentUser;

//  static Future<String> getCurrentUser() async {
//    try {
//      final currentFirebaseUser = _auth.currentUser;
//      if (currentFirebaseUser != null && currentFirebaseUser.emailVerified)
//        return currentFirebaseUser.uid;
//      else
//        return null;
//    } catch (e) {
//      print("ERROR WHILE GETTING CURRENT USER : $e");
//      return null;
//    }
//  }

  static Future<String> signInUser(String email, String password) async {
    email = email.trim().toLowerCase();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (_auth.currentUser != null) {
        if (_auth.currentUser.emailVerified) {
          return _auth.currentUser.uid;
        } else
          throw SignInException("EMAIL_NOT_VERIFIED");
      } else
        return null;
    } catch (e) {
      print("EXCEPTION WHILE LOGGING IN USER : $e");
      throw SignInException(e.message);
    }
  }

  static Future<bool> signUpUser(
      {String email, String password, String name}) async {
    email = email.trim().toLowerCase();
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await _auth.currentUser.sendEmailVerification();

      print("sent email");
      if (_auth.currentUser != null) {
        print("auth not null ${_auth.currentUser.uid}");
        await FirebaseStorageService.setUserData(_auth.currentUser.uid, {
          "name": name,
          "email": email,
          "photoUrl": kDefaultPhotoUrl,
          "contacts": {},
          "favoriteContactIds": [],
//          "chatrooms": [],
//          "friendRequestsPending": [],
//          "friendRequestsSent": [],
        });
        return true;
      } else
        return false;
    } catch (e) {
      print("EXCEPTION WHILE REGISTERING NEW USER : $e");
      throw SignUpException(e.message);
    }
  }

  static Future<void> changeCurrentUserPassword(
      String oldPassword, String newPassword) async {
    try {
      final User user = _auth.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);
    } catch (e) {
      print("ERROR WHILE CHANGING CURRENT USER PASSWORD : $e");
    }
  }

  static Future<void> changeCurrentUserEmail(
      {String newEmail, String password}) async {
    try {
      final User user = _auth.currentUser;

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      await user.updateEmail(newEmail);

      await user.sendEmailVerification();
    } catch (e) {
      print("ERROR WHILE CHANGING CURRENT USER EMAIL : $e");
    }
  }

  static Future<bool> logoutUser() async {
    try {
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
