import 'package:chatverse_chat_app/controllers/message_controller.dart';
import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/message.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/chatscreen_appbar_provider.dart';
import 'package:chatverse_chat_app/providers/loading_screen_provider.dart';
import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:chatverse_chat_app/utilities/theme_handler.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:chatverse_chat_app/widgets/date_separator.dart';
import 'package:chatverse_chat_app/widgets/delete_message_alert_dialog.dart';
import 'package:chatverse_chat_app/widgets/message_card.dart';
import 'package:chatverse_chat_app/widgets/profile_picture.dart';
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
  final ScrollController _scrollController = ScrollController();

  List<Message> messages;
  List messagesList;
  Map messagesDetails;

  Message message;
  int messagesLength;

  int unreadMessageCount;

  @override
  void dispose() {
    super.dispose();
    this._scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer3<User, LoadingScreenProvider, ChatScreenAppBarProvider>(
          builder: (context, user, loadingProvider, chatScreenAppBarProvider,
              snapshot) {
        Future<void> _deleteMessage({@required bool deleteForEveryone}) async {
          loadingProvider.startLoading();
          int index = chatScreenAppBarProvider.message.index;
          await FirebaseStorageService.deleteMessage(
            chatRoomId: this.widget.contact.chatRoomId,
            userId: user.id,
            contactId: this.widget.contact.id,
            messageIndex: index,
            deleteForEveryone: deleteForEveryone,
          );
          chatScreenAppBarProvider.unSelectMessage();
          loadingProvider.stopLoading();
        }

        return WillPopScope(
          onWillPop: () {
            chatScreenAppBarProvider.unSelectMessage();
            return Future.value(true);
          },
          child: CustomLoadingScreen(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(75),
                child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                      child: AnimatedCrossFade(
                        duration: Duration(milliseconds: 250),
                        // appbar when message is not selected
                        firstChild: AppBar(
                          leading: ProfilePicture(this.widget.contact.photoUrl),
                          centerTitle: true,
                          title: Text(this.widget.contact.name),
                          actions: [
                            IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        // appbar when message is selected
                        secondChild: AppBar(
                          leading: ProfilePicture(this.widget.contact.photoUrl),
                          centerTitle: false,
                          title: Text(this.widget.contact.name),
                          actions: [
                            // show buttons only if logged in user is sender
                            if (chatScreenAppBarProvider.messageIsSelected) ...[
                              if (!chatScreenAppBarProvider
                                  .message.isDeletedForMe) ...[
                                (chatScreenAppBarProvider.message.senderId ==
                                    user.id)
                                    ? IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.redAccent,
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      // user cannot dismiss alert dialog by pressing outside of the dialog
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return DeleteMessageAlertDialog(
                                          deleteForMeCallback: () async {
                                            await _deleteMessage(
                                                deleteForEveryone: false);
                                            chatScreenAppBarProvider
                                                .unSelectMessage();
                                            Navigator.pop(context);
                                          },
                                          deleteForEveryoneCallback:
                                              () async {
                                            await _deleteMessage(
                                                deleteForEveryone: true);
                                            chatScreenAppBarProvider
                                                .unSelectMessage();
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    );
                                  },
                                )
                                    : SizedBox.shrink(),
                                IconButton(
                                  icon: Icon(Icons.content_copy),
                                  onPressed: () {
                                    chatScreenAppBarProvider
                                        .copySelectedMessage();
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.forward),
                                  onPressed: () {},
                                ),
                              ],
                              IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  chatScreenAppBarProvider.unSelectMessage();
                                },
                              ),
                            ],
                          ],
                        ),
                        crossFadeState: chatScreenAppBarProvider.messageIsSelected
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                      ),
                    ),
                  ),
                  body: Column(
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseStorageService.getMessagesStream(
                            widget.contact.chatRoomId),
                        builder: (context, messageSnapshot) {
                          if (messageSnapshot.hasData) {
                            if (messageSnapshot.data.id ==
                                this.widget.contact.chatRoomId) {
                              FirebaseStorageService.resetUnreadMessages(
                                userId: user.id,
                                reference: messageSnapshot.data.reference,
                              );
                            }
                            final Map<String, dynamic> snapshotData =
                            messageSnapshot.data.data();
                            messagesList = snapshotData['messages'];
                            messagesDetails = snapshotData[user.id];

                            unreadMessageCount =
                            snapshotData[this.widget.contact.id]
                            ['unreadMessageCount'];
                            messages = [];

                            messagesLength = messagesList.length;
                            for (int i = messagesLength - 1; i >= 0; i--) {
                              message = Message.fromJSONString(messagesList[i]);
                              message.index = i;
                              message.isDeletedForMe =
                                  (messagesDetails['deletedMessagesIndex'] as List)
                                      .cast<int>()
                                      ?.contains(i) ??
                                      false;

                              // setting the last [unreadMessageCount] messages isRead as false
                              if (message.senderId == user.id) {
                                if (messagesLength - i <= unreadMessageCount)
                                  message.isRead = false;
                                else
                                  message.isRead = true;
                              }

                              messages.add(message);
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
                                    return DateSeparator(
                                        messages[index].displayDate);
                                  else
                                    return SizedBox.shrink();
                                },
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (chatScreenAppBarProvider
                                          .messageIsSelected) if (chatScreenAppBarProvider
                                          .message.index ==
                                          messages[index].index)
                                        chatScreenAppBarProvider.unSelectMessage();
                                      else
                                        chatScreenAppBarProvider.selectMessage(
                                            message: messages[index]);
                                    },
                                    onLongPress: () async {
                                      if (chatScreenAppBarProvider
                                          .messageIsSelected)
                                        chatScreenAppBarProvider.unSelectMessage();
                                      else
                                        chatScreenAppBarProvider.selectMessage(
                                            message: messages[index]);
                                    },
                                    child: Container(
                                      color: (chatScreenAppBarProvider
                                          .messageIsSelected &&
                                          chatScreenAppBarProvider
                                              .message.index ==
                                              messages[index].index)
                                          ? ThemeHandler
                                          .selectedContactBackgroundColor(
                                          context)
                                          : Colors.transparent,
                                      child: MessageCard(
                                        message: messages[index],
                                        chatRoomId: this.widget.contact.chatRoomId,
                                      ),
                                    ),
                                  );
                                },
                                itemCount: messages.length,
                              ),
                            );
                          } else
                            return CustomLoader();
                        },
                      ),
                      SendButtonTextField(
                        onSend: (String messageText) {
                          if (messageText != null && messageText != "") {
                            //FIXME: fix bug when sending a lot of messages and not sending
                            final String msg = messageText;
                            MessageController.sendMessage(
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
                            chatScreenAppBarProvider.unSelectMessage();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
