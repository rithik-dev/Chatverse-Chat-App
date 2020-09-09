import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
}
