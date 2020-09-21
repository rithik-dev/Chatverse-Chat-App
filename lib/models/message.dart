import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Message {
  bool isRead;
  bool isDeletedForMe;
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
    this.isDeletedForMe,
    this.displayTime,
    this.displayDate,
  });

  @override
  String toString() {
    return 'Message{isRead: $isRead, isDeletedForMe: $isDeletedForMe, text: $text, index: $index, displayTime: $displayTime, displayDate: $displayDate, senderId: $senderId}';
  }

  factory Message.fromJSONString(String encodedMessage) {
    final Map<String, dynamic> message =
    jsonDecode(encodedMessage) as Map<String, dynamic>;

    return Message(
      text: message['text'],
      senderId: message['senderId'],
      displayTime: message['displayTime'],
      displayDate: message['displayDate'],
      index: message['index'],
    );
  }

  String toJSONString() {
    final Map<String, dynamic> message = {
      'isRead': this.isRead,
      'isDeletedForMe': this.isDeletedForMe,
      'text': this.text,
      'displayTime': this.displayTime,
      'displayDate': this.displayDate,
      'senderId': this.senderId,
    };

    return jsonEncode(message);
  }
}
