import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/message.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/appbar_provider.dart';
import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
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
    return Consumer2<User, AppBarProvider>(
        builder: (context, user, appBarProvider, snapshot) {
      return GestureDetector(
        onTap: () {
          if (appBarProvider.contactIsSelected) if (appBarProvider.contactId ==
              contact.id)
            appBarProvider.unSelectContact();
          else
            appBarProvider.selectContact(
              contactId: contact.id,
              favoriteContactIds: user.favoriteContactIds,
            );
          else
            Navigator.pushNamed(context, ChatScreen.id, arguments: contact);
        },
        onLongPress: () async {
          if (appBarProvider.contactIsSelected)
            appBarProvider.unSelectContact();
          else
            appBarProvider.selectContact(
              contactId: contact.id,
              favoriteContactIds: user.favoriteContactIds,
            );
        },
        onVerticalDragStart: (details) {
          if (appBarProvider.contactIsSelected)
            appBarProvider.unSelectContact();
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
//              messagesList[i].addAll({"index": i});
                messages.add(Message.fromJSONString(messagesList[i]));
              }

              unreadMessagesCount =
                  snapshotData['unreadMessageCount(${user.id})'];
              hasUnreadMessages = unreadMessagesCount != 0;

              return Container(
                color: (appBarProvider.contactIsSelected &&
                        appBarProvider.contactId == contact.id)
                    ? ThemeHandler.selectedContactBackgroundColor(context)
                    : Colors.transparent,
                padding: EdgeInsets.all(5),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  margin: EdgeInsets.only(right: 25.0),
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
                      Row(
                        children: <Widget>[
                          Hero(
                            tag: contact.id,
                            child: ProfilePicture(contact.photoUrl, radius: 35),
                          ),
                          SizedBox(width: 10.0),
                          Column(
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
                                child: Text(
                                  messages.length == 0
                                      ? "Tap to start chatting..."
                                      : messages[0].text,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyText2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            messages.length == 0 ? "" : messages[0].displayTime,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText2,
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
}
