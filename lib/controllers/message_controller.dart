import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class MessageController {
  MessageController._();

  static Future<void> sendMessage({
    String contactId,
    String text,
    String senderId,
    String chatRoomId,
  }) async {
    final DateTime dateTime = await NTP.now();

    final Map<String, dynamic> message = {
      "text": text,
      "senderId": senderId,
      "displayTime": getDisplayTime(dateTime),
      "displayDate": getDisplayDate(dateTime),
    };

    await FirebaseStorageService.sendMessage(
      chatRoomId: chatRoomId,
      message: message,
      contactId: contactId,
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
