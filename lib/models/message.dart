import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' show DateFormat;

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
    String displayTime = getDisplayTime(dateTime);
    String displayDate = getDisplayDate(dateTime);

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

  static String getDisplayTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('KK:mm a');
    final String displayTime = formatter.format(dateTime);
    return displayTime;
  }

  static String getDisplayDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('d MMMM yyyy');
    final String displayDate = formatter.format(dateTime);
    return displayDate;
  }
}
