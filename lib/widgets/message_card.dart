import 'package:chatverse_chat_app/models/message.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  User user;

  MessageCard({@required this.message});

  bool senderIsMe;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    senderIsMe = user.id == message.senderId;
    return Container(
      margin: EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
        left: senderIsMe ? 80.0 : 0.0,
        right: senderIsMe ? 0.0 : 80.0,
      ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: senderIsMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
        borderRadius: senderIsMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.displayTime,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            message.text,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
