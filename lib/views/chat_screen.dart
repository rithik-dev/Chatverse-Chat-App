import 'package:chatverse_chat_app/controllers/message_controller.dart';
import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/message.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:chatverse_chat_app/widgets/date_separator.dart';
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
  List messagesList;

  String messageText;
  int messagesLength;

  int unreadMessageCount;

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
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseStorageService.getMessagesStream(
                widget.contact.chatRoomId),
            builder: (context, messageSnapshot) {
              if (messageSnapshot.hasData) {
                if (messageSnapshot.data.id == this.widget.contact.chatRoomId) {
                  FirebaseStorageService.resetUnreadMessages(
                    userId: this.user.id,
                    reference: messageSnapshot.data.reference,
                  );
                }
                final Map<String, dynamic> snapshotData =
                    messageSnapshot.data.data();
                messagesList = snapshotData['messages'];

                unreadMessageCount =
                    snapshotData[this.widget.contact.id]['unreadMessageCount'];
                print("unread $unreadMessageCount");
                messages = [];

                messagesLength = messagesList.length;
                for (int i = messagesLength - 1; i >= 0; i--) {
                  messagesList[i].addAll({"index": i});
                  // setting the last [unreadMessageCount] messages isRead as false
                  if (messagesList[i]['senderId'] == user.id) {
                    if (messagesLength - i <= unreadMessageCount)
                      messagesList[i]['isRead'] = false;
                    else
                      messagesList[i]['isRead'] = true;
                  }

                  messages.add(Message.fromMap(messagesList[i]));
                }

                return Expanded(
                  child: ListView.separated(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    reverse: true,
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      if (messages[index].displayDate !=
                          messages[index + 1].displayDate)
                        return DateSeparator(messages[index].displayDate);
                      else
                        return SizedBox.shrink();
                    },
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

                final String msg = messageText;
                messageText = "";
                await MessageController.sendMessage(
                  contactId: this.widget.contact.id,
                  text: msg,
                  chatRoomId: this.widget.contact.chatRoomId,
                  senderId: user.id,
                );

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
