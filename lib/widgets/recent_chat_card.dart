import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/message.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:chatverse_chat_app/views/chat_screen.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:chatverse_chat_app/widgets/profile_picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RecentChatCard extends StatelessWidget {
  final Contact contact;
  User user;
  bool hasUnreadMessages;
  int unreadMessagesCount;

  List<Message> messages = [];
  List messagesList = [];

  RecentChatCard({this.contact});

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ChatScreen.id, arguments: contact);
      },
      onLongPress: () {
        print("long press contact name ${contact.name} id ${contact.id}");
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
              messagesList[i].addAll({"index": i});
              messages.add(Message.fromMap(messagesList[i]));
            }

            //FIXME: called on null when fresh login
            unreadMessagesCount =
                snapshotData['unreadMessageCount(${user.id})'];
            hasUnreadMessages = unreadMessagesCount != 0;

            return Container(
              margin: EdgeInsets.only(top: 7.5, right: 20.0),
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: hasUnreadMessages ? Color(0xFFFFEFEE) : Colors.grey[200],
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
                      ProfilePicture(contact.photoUrl, radius: 35),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            contact.name,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Text(
                              messages.length == 0
                                  ? "Tap to start chatting..."
                                  : messages[0].text,
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
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
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      unreadMessagesCount > 0
                          ? Container(
                              width: 30.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                unreadMessagesCount >= 1000
                                    ? "999+"
                                    : unreadMessagesCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
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
            );
          } else
            return CustomLoader();
        },
      ),
    );
  }
}
