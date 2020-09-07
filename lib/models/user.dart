import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  String name;
  String email;
  String photoUrl;
  String userId;

  factory User.fromNullValues() {
    return User(
      name: null,
      email: null,
      photoUrl: null,
      userId: null,
    );
  }

  @override
  String toString() {
    return 'User{name: $name, email: $email, photoUrl: $photoUrl, userId: $userId}';
  }

  factory User.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> user = snapshot.data();
    return User(
      name: user['name'],
      email: user['email'],
      photoUrl: user['photoUrl'],
      userId: snapshot.id,
    );
  }

  void updateUserInProvider(User user) {
    this.name = user.name;
    this.email = user.email;
    this.photoUrl = user.photoUrl;
    this.userId = user.userId;
    notifyListeners();
  }

  User({
    @required this.name,
    @required this.email,
    @required this.photoUrl,
    @required this.userId,
  });
}
