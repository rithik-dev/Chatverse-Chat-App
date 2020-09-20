import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  String name;
  String email;
  String photoUrl;
  String id;
  String notificationToken;

//  List<String> friendRequestSentIds;
//  List<String> friendRequestPendingIds;
  Map<String, String> contacts;
  List<String> favoriteContactIds;

  factory User.fromNullValues() {
    return User(
      name: null,
      email: null,
      photoUrl: null,
      id: null,
//      friendRequestSentIds: null,
//      friendRequestPendingIds: null,
      favoriteContactIds: null,
      contacts: null,
    );
  }

  bool isInContacts(String contactId) {
    for (String id in this.contacts.keys) {
      if (id == contactId) return true;
    }
    return false;
  }

  bool isFavoriteContact(String contactId) {
    for (String id in this.favoriteContactIds) {
      if (id == contactId) return true;
    }
    return false;
  }

  factory User.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> user = snapshot.data();

    Map<String, String> _contacts =
        (user['contacts'] as Map<String, dynamic>).cast<String, String>();
    List<String> _favoriteContactIds =
        (user['favoriteContactIds'] as List<dynamic>).cast<String>().toList();

    return User(
      name: user['name'] as String,
      email: user['email'] as String,
      photoUrl: user['photoUrl'] as String,
//      friendRequestPendingIds: _friendRequestPendingIds,
//      friendRequestSentIds: _friendRequestSentIds,
      favoriteContactIds: _favoriteContactIds,
      contacts: _contacts,
      id: snapshot.id,
    );
  }


  void updateUserInProvider(User user) {
    this.name = user.name;
    this.email = user.email;
    this.photoUrl = user.photoUrl;
    this.id = user.id;
    this.contacts = user.contacts;
//    this.friendRequestPendingIds = user.friendRequestPendingIds;
//    this.friendRequestSentIds = user.friendRequestSentIds;
    this.favoriteContactIds = user.favoriteContactIds;

    notifyListeners();
  }

  User({
    @required this.name,
    @required this.email,
    @required this.photoUrl,
    @required this.id,
    @required this.contacts,
//    @required this.friendRequestPendingIds,
//    @required this.friendRequestSentIds,
    @required this.favoriteContactIds,
  });
}
