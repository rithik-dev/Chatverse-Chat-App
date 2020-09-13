import 'dart:convert';

import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
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
    final Map<String, String> display = await getDisplayDateAndTime();

    final Map<String, dynamic> message = {
      "text": text,
      "senderId": senderId,
      "displayTime": display['displayTime'],
      "displayDate": display['displayDate'],
    };

    final String encodedMessage = jsonEncode(message);

    await FirebaseStorageService.sendMessage(
      chatRoomId: chatRoomId,
      encodedMessage: encodedMessage,
      contactId: contactId,
    );
  }

  static Future<Map<String, String>> getDisplayDateAndTime() async {
    final DateTime dateTime = await NTP.now();
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
}
