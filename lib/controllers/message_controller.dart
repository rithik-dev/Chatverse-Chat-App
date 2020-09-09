import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MessageController {
  MessageController._();

  static Future<void> sendMessage(
      {String text, String senderId, String chatRoomId}) async {
    final Map<String, dynamic> message = {
      "isRead": false,
      "text": text,
      "senderId": senderId,
      "timestamp": Timestamp.now()
    };

    await FirebaseStorageService.sendMessage(
      chatRoomId: chatRoomId,
      message: message,
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
