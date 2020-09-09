import 'package:chatverse_chat_app/models/friend.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/services/firebase_auth_service.dart';
import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:chatverse_chat_app/utilities/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {
  static User _loggedInUser;

//  static Stream<QuerySnapshot> get userFriendsStream {
//    return FirebaseStorageService.getFriendsStream(_loggedInUser.userId);
//  }

  static Future<User> getUser(String userId) async {
    final DocumentSnapshot snapshot =
        await FirebaseStorageService.getUserDocumentSnapshot(userId);

    Map<String, dynamic> data = snapshot.data();

    List<Friend> friends = [];

    for (String friend in data['friends']) {
      DocumentSnapshot snapshot =
          await FirebaseStorageService.getUserDocumentSnapshot(friend);
      friends.add(Friend.fromDocumentSnapshot(snapshot));
    }

    _loggedInUser = User.fromDocumentSnapshot(snapshot);
    _loggedInUser.friends = friends;
    _loggedInUser.updateUserInProvider(_loggedInUser);
    print(_loggedInUser.toString());
    return _loggedInUser;
  }

  static String getChatRoomId(List<String> friendChatRoomIds) {
    print("called");
    print("djaskd ${_loggedInUser.toString()}");
    print('djaskldsjak ${friendChatRoomIds}');

//    final String chatRoomId = ChatRoomController.getChatRoomId(
//        _loggedInUser.chatRoomIds, friendChatRoomIds);
//    return chatRoomId;
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
