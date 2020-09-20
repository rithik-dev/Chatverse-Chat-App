import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/services/firebase_auth_service.dart';
import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:chatverse_chat_app/utilities/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {
  static User _loggedInUser;

  static Future<User> getUser(String userId) async {
    final DocumentSnapshot snapshot =
        await FirebaseStorageService.getUserDocumentSnapshot(userId);

//    Map<String, dynamic> data = snapshot.data();

//    List<Contact> contacts = [];

//    QuerySnapshot allUsersSnapshot = await FirebaseStorageService.getUsers();

//    for (QueryDocumentSnapshot snapshot in allUsersSnapshot.docs) {
//      if (data['contacts'].keys.contains(snapshot.id)) {
//        contacts.add(Contact.fromDocumentSnapshot(snapshot));
//      }
//    }

    _loggedInUser = User.fromDocumentSnapshot(snapshot);
//    _loggedInUser.contacts = contacts;
//    String contactId;
//
//    for (int index = 0; index < contacts.length; index++) {
//      contactId = contacts[index].id;
//      contacts[index].chatRoomId = data['contacts'][contactId];
//    }

    _loggedInUser.updateUserInProvider(_loggedInUser);
    return _loggedInUser;
  }

  static Future<void> updateName(String name) async {
    if (name == null || name.trim() == "") return;
    await FirebaseStorageService.updateUserDetails(
      userId: _loggedInUser.id,
      name: name,
    );
  }

//  static Future<Contact> addContact(String contactId) async {
//    String chatRoomId =
//        await FirebaseStorageService.addContact(_loggedInUser.id, contactId);
//    DocumentSnapshot snapshot =
//        await FirebaseStorageService.getUserDocumentSnapshot(contactId);
//    final Contact contact = Contact.fromDocumentSnapshot(snapshot);
//    contact.chatRoomId = chatRoomId;
//    return contact;
//  }

  static Future<void> addContactToFavorites(String contactId) async {
    await FirebaseStorageService.addContactToFavorites(
      userId: _loggedInUser.id,
      contactId: contactId,
    );
  }

  static Future<void> removeContactFromFavorites(String contactId) async {
    await FirebaseStorageService.removeContactFromFavorites(
        userId: _loggedInUser.id, contactId: contactId);
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
