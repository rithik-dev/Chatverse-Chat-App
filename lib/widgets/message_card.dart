import 'package:chatverse_chat_app/models/message.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MessageCard extends StatelessWidget {
  final Message message;
  User user;

  MessageCard({@required this.message});

  bool senderIsMe;

  double _getCardWidth(BuildContext context) {
    final int messageLength = message.text.length;
    final double maxWidth = MediaQuery.of(context).size.width * 0.85;
    final double minWidth = 165;
    final double width = messageLength * 12.0;
    if (width <= minWidth) return minWidth;
    if (width >= maxWidth) return maxWidth;

    return width;
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    senderIsMe = user.id == message.senderId;
    return GestureDetector(
      onLongPress: () {
        // TODO: add options like copy message text, delete, forward
        if (user.id == message.senderId)
          print("long pressed msg id : ${message.id} ${message.text}");
      },
      child: Column(
        crossAxisAlignment:
            senderIsMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            width: this._getCardWidth(context),
            margin: EdgeInsets.symmetric(vertical: 2.5),
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: senderIsMe
                  ? Theme.of(context).accentColor
                  : Color(0xFFFFEFEE),
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
              crossAxisAlignment: senderIsMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                SelectableText(
                  message.text,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: senderIsMe
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message.displayTime,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    senderIsMe ? SizedBox(width: 10.0) : SizedBox.shrink(),
                    senderIsMe
                        ? Icon(
                            message.isRead
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color: Colors.green,
                            size: 22,
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
