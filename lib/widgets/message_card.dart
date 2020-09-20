import 'package:chatverse_chat_app/models/message.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/utilities/theme_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MessageCard extends StatelessWidget {
  final Message message;
  final String chatRoomId;
  final VoidCallback onLongPress;
  User user;

  MessageCard({
    @required this.message,
    @required this.chatRoomId,
    @required this.onLongPress,
  });

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
      onLongPress: this.onLongPress,
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
                  ? ThemeHandler.myMessageCardColor(context)
                  : ThemeHandler.contactMessageCardColor(context),
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
                  style: TextStyle(fontSize: 15),
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
                      style: Theme
                          .of(context)
                          .textTheme
                          .subtitle2,
                    ),
                    senderIsMe ? SizedBox(width: 10.0) : SizedBox.shrink(),
                    senderIsMe
                        ? Icon(
                      message.isRead
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      size: 20,
                      color: Theme
                          .of(context)
                          .accentColor,
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
