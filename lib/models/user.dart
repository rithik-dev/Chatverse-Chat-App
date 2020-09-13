import 'package:chatverse_chat_app/models/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  String name;
  String email;
  String photoUrl;
  String id;
  List<String> friendRequestSentIds;
  List<String> friendRequestPendingIds;
  List<Contact> contacts;

  factory User.fromNullValues() {
    return User(
      name: null,
      email: null,
      photoUrl: null,
      id: null,
      friendRequestSentIds: null,
      friendRequestPendingIds: null,
      contacts: null,
    );
  }


  factory User.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> user = snapshot.data();

    List<String> _friendRequestSentIds =
        (user['friendRequestsSent'] as List<dynamic>).cast<String>();
    List<String> _friendRequestPendingIds =
        (user['friendRequestsPending'] as List<dynamic>).cast<String>();

    return User(
      name: user['name'] as String,
      email: user['email'] as String,
      photoUrl: user['photoUrl'] as String,
      friendRequestPendingIds: _friendRequestPendingIds,
      friendRequestSentIds: _friendRequestSentIds,
      id: snapshot.id,
      contacts: [],
    );
  }

  @override
  String toString() {
    return 'User{name: $name, email: $email, photoUrl: $photoUrl, id: $id, friendRequestSentIds: $friendRequestSentIds, friendRequestPendingIds: $friendRequestPendingIds, contacts: $contacts}';
  }

  void updateUserInProvider(User user) {
    this.name = user.name;
    this.email = user.email;
    this.photoUrl = user.photoUrl;
    this.id = user.id;
    this.contacts = user.contacts;
    this.friendRequestPendingIds = user.friendRequestPendingIds;
    this.friendRequestSentIds = user.friendRequestSentIds;

    notifyListeners();
  }

  User({
    @required this.name,
    @required this.email,
    @required this.photoUrl,
    @required this.id,
    @required this.contacts,
    @required this.friendRequestPendingIds,
    @required this.friendRequestSentIds,
  });
}
