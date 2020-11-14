import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/message.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/homescreen_appbar_provider.dart';
import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:chatverse_chat_app/utilities/constants.dart';
import 'package:chatverse_chat_app/utilities/theme_handler.dart';
import 'package:chatverse_chat_app/views/chat_screen.dart';
import 'package:chatverse_chat_app/widgets/profile_picture.dart';
import 'package:chatverse_chat_app/widgets/recent_chat_card_shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RecentChatCard extends StatelessWidget {
  final Contact contact;
  bool hasUnreadMessages;
  int unreadMessagesCount;

  List<Message> messages = [];
  List messagesList = [];

  RecentChatCard({this.contact});

  @override
  Widget build(BuildContext context) {
    return Consumer2<User, HomeScreenAppBarProvider>(
        builder: (context, user, homeScreenAppBarProvider, snapshot) {
      return GestureDetector(
        onTap: () {
          if (homeScreenAppBarProvider
              .contactIsSelected) if (homeScreenAppBarProvider
                  .contactId ==
              contact.id)
            homeScreenAppBarProvider.unSelectContact();
          else
            homeScreenAppBarProvider.selectContact(
              contactId: contact.id,
              favoriteContactIds: user.favoriteContactIds,
            );
          else
            Navigator.pushNamed(context, ChatScreen.id, arguments: {
              'contact': contact,
              'profilePicHeroTag': contact.id + "-recent",
            });
        },
        onLongPress: () async {
          if (homeScreenAppBarProvider.contactIsSelected)
            homeScreenAppBarProvider.unSelectContact();
          else
            homeScreenAppBarProvider.selectContact(
              contactId: contact.id,
              favoriteContactIds: user.favoriteContactIds,
            );
        },
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseStorageService.getMessagesStream(contact.chatRoomId),
          builder: (context, messagesAsyncSnapshot) {
            if (messagesAsyncSnapshot.hasData) {
              final Map<String, dynamic> snapshotData =
                  messagesAsyncSnapshot.data.data();
              messagesList = snapshotData['messages'];

              messages = [];

              for (int i = messagesList.length - 1; i >= 0; i--) {
                final Message message = Message.fromJSONString(messagesList[i]);
                message.index = i;
                message.isDeleted =
                    (snapshotData[user.id]['deletedMessagesIndex'] as List)
                            .cast<int>()
                            ?.contains(i) ??
                        false;

                if (message.isDeleted) message.content = kDeletedMessageString;
                messages.add(message);
              }

              // my unread messages
              unreadMessagesCount = snapshotData[user.id]['unreadMessageCount'];
              hasUnreadMessages = unreadMessagesCount != 0;

              // contacts unread messages
              // using this to show the message seen tick if value is more than 0
              final bool contactHasReadLastMessage =
                  snapshotData[contact.id]['unreadMessageCount'] == 0;

              //FIXME: extremely long name overflow error
              return Container(
                color: (homeScreenAppBarProvider.contactIsSelected &&
                        homeScreenAppBarProvider.contactId == contact.id)
                    ? ThemeHandler.selectedContactBackgroundColor(context)
                    : Colors.transparent,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: hasUnreadMessages
                        ? ThemeHandler.unreadMessageBackgroundColor(context)
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Hero(
                        tag: contact.id + "-recent",
                        child: ProfilePicture(contact.photoUrl, radius: 35),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              contact.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Row(
                                children: [
                                  this.messages.length != 0 &&
                                          this.messages[0].senderId == user.id
                                      ? Icon(
                                          contactHasReadLastMessage
                                              ? Icons.check_circle
                                              : Icons.check_circle_outline,
                                          size: 15,
                                          color: Theme.of(context).accentColor,
                                        )
                                      : SizedBox.shrink(),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      this._getMessageContent(
                                        messages: messages,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            fontStyle:
                                                this._getMessageFontStyle(
                                              messages: messages,
                                            ),
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            messages.length == 0 ? "" : messages[0].displayTime,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          SizedBox(height: 10.0),
                          unreadMessagesCount > 0
                              ? Container(
                                  width: 30.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Color(0xFFe43f5a),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    unreadMessagesCount >= 1000
                                        ? "999+"
                                        : unreadMessagesCount.toString(),
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : Text(''),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else
              return RecentChatCardShimmer();
          },
        ),
      );
        });
  }

  String _getMessageContent({List<Message> messages}) {
    if (messages.length == 0) return "Tap to start chatting...";
    if (messages[0].isDeleted) return kDeletedMessageString;
    if (messages[0].type == MessageType.photo)
      return "Photo";
    else if (messages[0].type == MessageType.video)
      return "Video";
    else
      return messages[0].content;
  }

  FontStyle _getMessageFontStyle({List<Message> messages}) {
    if (messages.length == 0 ||
        messages[0].isDeleted ||
        messages[0].type == MessageType.photo ||
        messages[0].type == MessageType.video) return FontStyle.italic;

    return FontStyle.normal;
  }
}
