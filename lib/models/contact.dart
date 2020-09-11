import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Contact {
  String id;
  String name;
  String photoUrl;
  String email;
  String chatRoomId;

  Contact({
    @required this.id,
    @required this.name,
    @required this.photoUrl,
    @required this.email,
  });

  factory Contact.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> contact = snapshot.data();

    return Contact(
      name: contact['name'] as String,
      photoUrl: contact['photoUrl'] as String,
      email: contact['email'] as String,
      id: snapshot.id,
    );
  }
}
