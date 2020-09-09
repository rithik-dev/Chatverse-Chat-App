import 'package:chatverse_chat_app/controllers/chat_room_controller.dart';
import 'package:chatverse_chat_app/controllers/message_controller.dart';
import 'package:chatverse_chat_app/models/friend.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:chatverse_chat_app/views/chat_screen.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:chatverse_chat_app/widgets/profile_picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentChatCard extends StatelessWidget {
  final Friend friend;
  User user;
  String chatRoomId;

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
      child: Stack(
        children: [
          Container(
              height: 80,
              width: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.only(left: 50, top: 12, bottom: 12, right: 10),
              padding:
                  EdgeInsets.only(left: 50, right: 10, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: Offset(1, 1))
                ],
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFB9245),
                    Color(0xFFF54E6B),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseStorageService.getMessagesStream(chatRoomId),
                  builder: (context, messagesAsyncSnapshot) {
                    if (messagesAsyncSnapshot.hasData) {
                      List<QueryDocumentSnapshot> messagesSnapshots =
                          messagesAsyncSnapshot.data.docs;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    friend.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text(
                                    messagesSnapshots.length == 0
                                        ? "Tap to start chatting..."
                                        : messagesSnapshots[0].data()['text'],
                                    style: TextStyle(
                                      color: Colors.grey[900],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ]),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                  messagesSnapshots.length == 0
                                      ? ""
                                      : MessageController.getDisplayTime(
                                          (messagesSnapshots[0]
                                                      .data()['timestamp']
                                                  as Timestamp)
                                              .toDate()),
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              Builder(
                                builder: (_) {
                                  final unreadMessageCount =
                                      _getUnreadMessageCount(messagesSnapshots);
                                  if (unreadMessageCount == 0) {
                                    return SizedBox.shrink();
                                  } else {
                                    String unreadMessageString;
                                    if (unreadMessageCount >= 100)
                                      unreadMessageString = "99+";
                                    else
                                      unreadMessageString =
                                          unreadMessageCount.toString();
                                    return CircleAvatar(
                                      backgroundColor: Colors.yellow,
                                      child: Text(
                                        unreadMessageString,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      radius: 15,
                                    );
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      );
                    } else
                      return CustomLoader();
                  })),
          Positioned(
            top: 7,
            left: 10,
            child: ProfilePicture(
              "https://firebasestorage.googleapis.com/v0/b/password-manager-2083b.appspot.com/o/Profile%20Pictures%2FWo8TXzCwWOXzqkpxpX578Mv5mt23.png?alt=media&token=a8028fb0-c177-4b60-a4cb-d133c08713ca",
              radius: 45,
            ),
          ),
        ],
      ),
    );
  }

  int _getUnreadMessageCount(List<QueryDocumentSnapshot> messagesSnapshot) {
    int unreadMessageCount = 0;
    for (DocumentSnapshot messageSnapshot in messagesSnapshot) {
      final Map<String, dynamic> message = messageSnapshot.data();
      if (message['senderId'] != user.id) if (message['isRead'] == false)
        unreadMessageCount++;
    }
    return unreadMessageCount;
  }
}

//Column
//(
//children: [
//Row
//(
//mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
//Expanded
//(
//child:)
//,
//
//]
//,
//)
//,
//SizedBox
//(
//height: 10
//)
//,
//Row
//(
//mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
//Expanded
//(
//child:)
//,
//CircleAvatar
//(
//backgroundColor: Colors.green,child: Text
//("99+
//"
//,
//style: TextStyle
//(
//fontSize: 13
//,
//color: Colors.black87),
//)
//,
//radius: 17,
//)
//],
//)
//],
//),
