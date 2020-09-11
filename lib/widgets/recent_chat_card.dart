import 'package:chatverse_chat_app/controllers/chat_room_controller.dart';
import 'package:chatverse_chat_app/models/friend.dart';
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
  final Friend friend;
  User user;
  String chatRoomId;
  bool hasUnreadMessages;
  int unreadMessagesCount;

  List<Message> messages = [];

  RecentChatCard({this.friend});

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    chatRoomId =
        ChatRoomController.getChatRoomId(user.chatRoomIds, friend.chatRoomIds);
    return GestureDetector(
      onTap: () {
        friend.chatRoomId = chatRoomId;

        print(chatRoomId);
        Navigator.pushNamed(context, ChatScreen.id, arguments: friend);
      },
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseStorageService.getMessagesStream(chatRoomId),
        builder: (context, messagesAsyncSnapshot) {
          if (messagesAsyncSnapshot.hasData) {
            List<QueryDocumentSnapshot> messagesSnapshots =
                messagesAsyncSnapshot.data.docs;

            messages = [];
            for (DocumentSnapshot documentSnapshot in messagesSnapshots) {
              messages.add(Message.fromDocumentSnapshot(documentSnapshot));
            }

            unreadMessagesCount = _getUnreadMessageCount(messages);
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
                      ProfilePicture(
                        "https://firebasestorage.googleapis.com/v0/b/password-manager-2083b.appspot.com/o/Profile%20Pictures%2FWo8TXzCwWOXzqkpxpX578Mv5mt23.png?alt=media&token=a8028fb0-c177-4b60-a4cb-d133c08713ca",
                        radius: 35,
                      ),
//                      ProfilePicture(friend.photoUrl, radius: 35),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            friend.name,
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
                              messagesSnapshots.length == 0
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
                        messages[0].displayTime,
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

  int _getUnreadMessageCount(List<Message> messages) {
    int unreadMessageCount = 0;
    for (Message message in messages) {
      if (message.senderId != user.id && message.isRead == false)
        unreadMessageCount++;
    }
    return unreadMessageCount;
  }
}
