import 'dart:convert';

import 'package:flutter/cupertino.dart';

enum MessageType {
  photo,
  video,
  text,
//  audio,
}

class Message {
  bool isRead;
  bool isDeleted;
  String text;
  MessageType messageType;

  int index;
  String displayTime;
  String displayDate;
  String senderId;

  Message({
    @required this.text,
    @required this.index,
    @required this.senderId,
    this.isRead,
    this.isDeleted,
    this.displayTime,
    this.displayDate,
  });

  @override
  String toString() {
    return 'Message{isRead: $isRead, isDeletedForMe: $isDeleted, text: $text, index: $index, displayTime: $displayTime, displayDate: $displayDate, senderId: $senderId}';
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
      'isDeletedForMe': this.isDeleted,
      'text': this.text,
      'displayTime': this.displayTime,
      'displayDate': this.displayDate,
      'senderId': this.senderId,
    };

    return jsonEncode(message);
  }
}
