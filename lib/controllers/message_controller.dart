import 'dart:convert';
import 'dart:io';

import 'package:chatverse_chat_app/models/message.dart';
import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ntp/ntp.dart' show NTP;

class MessageController {
  MessageController._();

  static Future<void> sendTextMessage({
    String contactId,
    String text,
    String senderId,
    String chatRoomId,
    DateTime dateTime,
    MessageType messageType,
  }) async {
    int _timeStampMicroSeconds;
    if (dateTime == null) {
      final DateTime _dateTime = await NTP.now();
      _timeStampMicroSeconds =
          Timestamp.fromDate(_dateTime).microsecondsSinceEpoch;
    } else {
      _timeStampMicroSeconds =
          Timestamp.fromDate(dateTime).microsecondsSinceEpoch;
    }

    final String _messageTypeString = Message.getMessageTypeString(messageType);

    final Map<String, dynamic> message = {
      "text": text,
      "senderId": senderId,
      "timeStampMicroSeconds": _timeStampMicroSeconds,
      "type": _messageTypeString
    };

    final String encodedMessage = jsonEncode(message);

    await FirebaseStorageService.sendMessage(
      chatRoomId: chatRoomId,
      encodedMessage: encodedMessage,
      contactId: contactId,
    );
  }

  static Future<void> sendMediaMessage({
    String contactId,
    File file,
    String senderId,
    String chatRoomId,
    MessageType messageType,
  }) async {
    final DateTime dateTime = await NTP.now();

    final String fileUrl = await FirebaseStorageService.uploadMediaMessage(
      userId: senderId,
      image: file,
      timestamp: dateTime.toString(),
      messageType: messageType,
    );

    print("upload url $fileUrl");

    await sendTextMessage(
      contactId: contactId,
      text: fileUrl,
      senderId: senderId,
      chatRoomId: chatRoomId,
      dateTime: dateTime,
      messageType: messageType,
    );
  }
}
