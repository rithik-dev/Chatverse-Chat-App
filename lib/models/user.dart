import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  String name;
  String email;
  String profilePicURL;
  String userId;

  factory User.fromNullValues() {
    return User(
      name: null,
      email: null,
      profilePicURL: null,
      userId: null,
    );
  }

  @override
  String toString() {
    return 'User{name: $name, email: $email, profilePicURL: $profilePicURL, userId: $userId}';
  }

  factory User.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return User(
      name: snapshot.data['name'],
      email: snapshot.data['email'],
      profilePicURL: snapshot.data['profilePicURL'],
      userId: snapshot.documentID,
    );
  }

  void updateUserInProvider(User user) {
    this.name = user.name;
    this.email = user.email;
    this.profilePicURL = user.profilePicURL;
    this.userId = user.userId;
    notifyListeners();
  }

  User({
    @required this.name,
    @required this.email,
    @required this.profilePicURL,
    @required this.userId,
  });
}
