import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:ntp/ntp.dart' show NTP;

class MessageController {
  MessageController._();

  static Future<void> sendMessage({
    String contactId,
    String text,
    String senderId,
    String chatRoomId,
  }) async {
    final DateTime dateTime = await NTP.now();
    final Timestamp _timestamp = Timestamp.fromDate(dateTime);

    final Map<String, dynamic> message = {
      "text": text,
      "senderId": senderId,
      "timestamp": _timestamp,
    };

    await FirebaseStorageService.sendMessage(
      chatRoomId: chatRoomId,
      message: message,
      contactId: contactId,
    );
  }

  static String getDisplayTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('h:mm a');
    final String displayTime = formatter.format(dateTime);
    return displayTime;
  }

  static String getDisplayDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('d MMMM yyyy');
    final String displayDate = formatter.format(dateTime);
    return displayDate;
  }
}
