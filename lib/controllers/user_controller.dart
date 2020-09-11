import 'package:chatverse_chat_app/models/contact.dart';
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

    Map<String, dynamic> data = snapshot.data();

    List<Contact> contacts = [];

    for (String contact in data['contacts']) {
      DocumentSnapshot snapshot =
          await FirebaseStorageService.getUserDocumentSnapshot(contact);
      contacts.add(Contact.fromDocumentSnapshot(snapshot));
    }

    _loggedInUser = User.fromDocumentSnapshot(snapshot);
    _loggedInUser.contacts = contacts;

    for (int index = 0; index < contacts.length; index++) {
      contacts[index].chatRoomId = _loggedInUser.chatRoomIds[index];
    }

    _loggedInUser.updateUserInProvider(_loggedInUser);
    return _loggedInUser;
  }

  static Future<Contact> addContact(String contactId) async {
    String chatRoomId =
        await FirebaseStorageService.addContact(_loggedInUser.id, contactId);
    DocumentSnapshot snapshot =
        await FirebaseStorageService.getUserDocumentSnapshot(contactId);
    final Contact contact = Contact.fromDocumentSnapshot(snapshot);
    contact.chatRoomId = chatRoomId;
    return contact;
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
