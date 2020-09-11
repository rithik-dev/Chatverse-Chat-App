import 'package:chatverse_chat_app/controllers/message_controller.dart';
import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/message.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:chatverse_chat_app/widgets/message_card.dart';
import 'package:chatverse_chat_app/widgets/send_button_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const id = 'chat_screen';
  final Contact contact;

  ChatScreen({@required this.contact});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User user;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  List<Message> messages;
  Message message;

  String messageText;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseStorageService.getMessagesStream(
                widget.contact.chatRoomId),
            builder: (context, messageSnapshots) {
              if (messageSnapshots.hasData) {
                messages = [];
                for (DocumentSnapshot snapshot in messageSnapshots.data.docs) {
                  message = Message.fromDocumentSnapshot(snapshot);
                  if (message.senderId != user.id)
                    FirebaseStorageService.setMessagesReadToTrue(
                      snapshot.reference,
                    );

                  messages.add(message);
                }

                return Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) =>
                        MessageCard(message: messages[index]),
                    itemCount: messages.length,
                  ),
                );
              } else
                return CustomLoader();
            },
          ),
          SendButtonTextField(
            controller: _messageController,
            onChanged: (String msg) {
              messageText = msg;
            },
            onSend: () async {
              if (messageText != null && messageText != "") {
                _messageController.clear();

                MessageController.sendMessage(
                  text: messageText,
                  chatRoomId: widget.contact.chatRoomId,
                  senderId: user.id,
                );

                messageText = "";

                _scrollController.animateTo(
                  0.0,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
