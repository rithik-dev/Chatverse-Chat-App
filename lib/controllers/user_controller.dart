import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/services/firebase_auth_service.dart';
import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:chatverse_chat_app/utilities/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {
  static User _loggedInUser;

  static Stream<QuerySnapshot> get userFriendsStream {
    return FirebaseStorageService.getFriendsStream(_loggedInUser.userId);
  }

  static Future<User> getUser(String userId) async {
    final DocumentSnapshot snapshot =
        await FirebaseStorageService.getUserDocumentSnapshot(userId);
    _loggedInUser = User.fromDocumentSnapshot(snapshot);
    return _loggedInUser;
  }

  static Future<bool> signUpUser(
      {String email, String password, String name}) async {
    final bool success = await FirebaseAuthService.signUpUser(
      email: email,
      password: password,
      name: name,
    );
    return success;
  }

  static Future<User> signInUser(String email, String password) async {
    String userId = await FirebaseAuthService.signInUser(email, password);
    await SharedPrefs.setLoggedInUserID(userId);
    _loggedInUser = await getUser(userId);
    return _loggedInUser;
  }

  static Future<User> logoutUser() async {
    await FirebaseAuthService.logoutUser();
    await SharedPrefs.setLoggedInUserID(null);
    _loggedInUser = User.fromNullValues();
    return _loggedInUser;
  }
}
