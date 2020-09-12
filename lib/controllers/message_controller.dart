import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MessageController {
  MessageController._();

  static Future<void> sendMessage({
    String contactId,
    String text,
    String senderId,
    String chatRoomId,
  }) async {
    final Map<String, dynamic> message = {
      "text": text,
      "senderId": senderId,
      "displayTime": getDisplayTime(),
//      "displayDate": getDisplayDate()
    };

    await FirebaseStorageService.sendMessage(
      chatRoomId: chatRoomId,
      message: message,
      contactId: contactId,
    );
  }

  static String getDisplayTime() {
    final DateTime dateTime = Timestamp.now().toDate();
    final DateFormat formatter = DateFormat('KK:mm a');
    final String displayTime = formatter.format(dateTime);
    return displayTime;
  }

//  static String getDisplayDate() {
//    final DateTime dateTime = Timestamp.now().toDate();
//    final DateFormat formatter = DateFormat('d MMMM yyyy');
//    final String displayDate = formatter.format(dateTime);
//    return displayDate;
//  }
}
