import 'package:chatverse_chat_app/controllers/message_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Message {
  bool isRead;
  String text;
  Timestamp timestamp;
  String id;
  String displayTime;
  String displayDate;
  String senderId;

  Message({
    @required this.isRead,
    @required this.text,
    @required this.timestamp,
    @required this.id,
    @required this.senderId,
    this.displayTime,
    this.displayDate,
  });

  @override
  String toString() {
    return 'Message{isRead: $isRead, text: $text, timestamp: $timestamp, id: $id, displayTime: $displayTime, displayDate: $displayDate, senderId: $senderId}';
  }

  factory Message.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> message = snapshot.data();

    final DateTime dateTime = (message['timestamp'] as Timestamp).toDate();
    String displayTime = MessageController.getDisplayTime(dateTime);
    String displayDate = MessageController.getDisplayDate(dateTime);

    return Message(
      isRead: message['isRead'] as bool,
      text: message['text'] as String,
      senderId: message['senderId'] as String,
      timestamp: message['timestamp'] as Timestamp,
      displayTime: displayTime,
      displayDate: displayDate,
      id: snapshot.id,
    );
  }
}
