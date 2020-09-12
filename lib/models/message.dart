import 'package:chatverse_chat_app/controllers/message_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Message {
  bool isRead;
  String text;
  int index;
  String displayTime;
  String displayDate;
  String senderId;

  Message({
    @required this.text,
    @required this.index,
    @required this.senderId,
    this.isRead,
    this.displayTime,
    this.displayDate,
  });

  @override
  String toString() {
    return 'Message{isRead: $isRead, text: $text, index: $index, displayTime: $displayTime, senderId: $senderId}';
  }

  factory Message.fromMap(Map<String, dynamic> message) {
    final DateTime dateTime = (message['timestamp'] as Timestamp).toDate();

    final String _displayTime = MessageController.getDisplayTime(dateTime);
    final String _displayDate = MessageController.getDisplayDate(dateTime);

    return Message(
      text: message['text'] as String,
      isRead: message['isRead'] as bool,
      senderId: message['senderId'] as String,
      displayTime: _displayTime,
      displayDate: _displayDate,
      index: message['index'],
    );
  }
}
