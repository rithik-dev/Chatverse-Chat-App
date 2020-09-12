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
    return Message(
      text: message['text'] as String,
      isRead: message['isRead'] as bool,
      senderId: message['senderId'] as String,
      displayTime: message['displayTime'] as String,
      displayDate: message['displayDate'] as String,
      index: message['index'],
    );
  }
}
