import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Friend {
  String id;
  String name;
  String photoUrl;
  String email;
  List<String> chatRoomIds;
  String lastMessageDisplayTime;
  String lastMessage;
  int unreadMessages;
  String chatRoomId;

  Friend({
    @required this.id,
    @required this.name,
    @required this.photoUrl,
    @required this.email,
    @required this.chatRoomIds,
    this.lastMessage,
    this.lastMessageDisplayTime,
    this.unreadMessages,
  });

  @override
  String toString() {
    return 'Friend{id: $id, name: $name, photoUrl: $photoUrl, email: $email, chatRoomIds: $chatRoomIds, lastMessageDisplayTime: $lastMessageDisplayTime, lastMessage: $lastMessage, unreadMessages: $unreadMessages}';
  }

  factory Friend.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> friend = snapshot.data();

    List<String> _chatRoomIds =
        (friend['chatrooms'] as List<dynamic>).cast<String>();

    //TODO: change photo url to friend['photoUrl'] as String
    return Friend(
      name: friend['name'] as String,
      photoUrl:
          "https://firebasestorage.googleapis.com/v0/b/password-manager-2083b.appspot.com/o/Profile%20Pictures%2FWo8TXzCwWOXzqkpxpX578Mv5mt23.png?alt=media&token=a8028fb0-c177-4b60-a4cb-d133c08713ca",
      email: friend['email'] as String,
      chatRoomIds: _chatRoomIds,
      lastMessage: "this is last msg",
      unreadMessages: 5,
      lastMessageDisplayTime: "09:11 AM",
      id: snapshot.id,
    );
  }
}
