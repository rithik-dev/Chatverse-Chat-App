import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' show DateFormat;

enum MessageType {
  photo,
  video,
  text,
//  audio,
}

class Message {
  bool isRead;
  bool isDeleted;
  String content;
  MessageType type;

  int index;
  String displayTime;
  String displayDate;
  String senderId;

  Message({
    @required this.content,
    @required this.index,
    @required this.senderId,
    @required this.type,
    this.isRead,
    this.isDeleted,
    this.displayTime,
    this.displayDate,
  });

  @override
  String toString() {
    return 'Message{isRead: $isRead, isDeletedForMe: $isDeleted, text: $content, index: $index, displayTime: $displayTime, displayDate: $displayDate, senderId: $senderId}';
  }

  factory Message.fromJSONString(String encodedMessage) {
    final Map<String, dynamic> message =
        jsonDecode(encodedMessage) as Map<String, dynamic>;

    final Map<String, String> displayDateAndTime =
        getDisplayDateAndTime(message['timeStampMicroSeconds'] as int);

    return Message(
      content: message['text'],
      senderId: message['senderId'],
      type: _getMessageType(message['type']),
      displayTime: displayDateAndTime['displayTime'],
      displayDate: displayDateAndTime['displayDate'],
      index: message['index'],
    );
  }

  String toJSONString() {
    final Map<String, dynamic> message = {
      'isRead': this.isRead,
      'isDeletedForMe': this.isDeleted,
      'text': this.content,
      'type': this.type,
      'displayTime': this.displayTime,
      'displayDate': this.displayDate,
      'senderId': this.senderId,
    };

    return jsonEncode(message);
  }

  static Map<String, String> getDisplayDateAndTime(int timeStampMicroSeconds) {
    Timestamp timestamp =
    Timestamp.fromMicrosecondsSinceEpoch(timeStampMicroSeconds);
    final DateTime dateTime = timestamp.toDate();
    DateFormat formatter;
    String displayTime;
    String displayDate;

    formatter = DateFormat('h:mm a');
    displayTime = formatter.format(dateTime);

    formatter = DateFormat('d MMMM yyyy');
    displayDate = formatter.format(dateTime);

    return {
      'displayTime': displayTime,
      'displayDate': displayDate,
    };
  }

  // ignore: missing_return
  static MessageType _getMessageType(String messageType) {
    if (messageType == 'photo')
      return MessageType.photo;
    else if (messageType == 'video')
      return MessageType.video;
    else
      return MessageType.text;
  }

  static String getMessageTypeString(MessageType messageType) {
    if (messageType == MessageType.photo)
      return 'photo';
    else if (messageType == MessageType.video)
      return 'video';
    else
      return 'text';
  }
}
