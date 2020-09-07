import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String sender;
  bool isRead;
  String text;
  Timestamp time;
}
