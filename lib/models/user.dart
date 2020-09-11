import 'package:chatverse_chat_app/models/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  String name;
  String email;
  String photoUrl;
  String id;
  List<String> contactIds;
  List<String> chatRoomIds;
  List<String> friendRequestSentIds;
  List<String> friendRequestPendingIds;
  List<Contact> contacts;

  factory User.fromNullValues() {
    return User(
      name: null,
      email: null,
      photoUrl: null,
      id: null,
      contactIds: null,
      friendRequestSentIds: null,
      friendRequestPendingIds: null,
      chatRoomIds: null,
      contacts: null,
    );
  }

  @override
  String toString() {
    return 'User{name: $name, email: $email, photoUrl: $photoUrl, id: $id, contactIds: $contactIds, chatRoomIds: $chatRoomIds, friendRequestSentIds: $friendRequestSentIds, friendRequestPendingIds: $friendRequestPendingIds, friends: $contacts}';
  }

  factory User.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> user = snapshot.data();

    List<String> _contactIds =
        (user['contacts'] as List<dynamic>).cast<String>();
    List<String> _chatRoomIds =
        (user['chatrooms'] as List<dynamic>).cast<String>();
    List<String> _friendRequestSentIds =
        (user['friendRequestsSent'] as List<dynamic>).cast<String>();
    List<String> _friendRequestPendingIds =
        (user['friendRequestsPending'] as List<dynamic>).cast<String>();

    return User(
      name: user['name'] as String,
      email: user['email'] as String,
      photoUrl: user['photoUrl'] as String,
      contactIds: _contactIds,
      chatRoomIds: _chatRoomIds,
      friendRequestPendingIds: _friendRequestPendingIds,
      friendRequestSentIds: _friendRequestSentIds,
      id: snapshot.id,
      contacts: [],
    );
  }

  void updateUserInProvider(User user) {
    this.name = user.name;
    this.email = user.email;
    this.photoUrl = user.photoUrl;
    this.id = user.id;
    this.contacts = user.contacts;
    this.chatRoomIds = user.chatRoomIds;
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
    @required this.contactIds,
    @required this.chatRoomIds,
    @required this.friendRequestPendingIds,
    @required this.friendRequestSentIds,
  });
}
