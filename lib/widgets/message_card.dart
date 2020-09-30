import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatverse_chat_app/models/message.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/chatscreen_appbar_provider.dart';
import 'package:chatverse_chat_app/utilities/theme_handler.dart';
import 'package:chatverse_chat_app/widgets/custom_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MessageCard extends StatelessWidget {
  final Message message;
  final String chatRoomId;
  User user;
  ChatScreenAppBarProvider chatScreenAppBarProvider;

  MessageCard({
    @required this.message,
    @required this.chatRoomId,
  });

  bool senderIsMe;

  double _getCardWidth(BuildContext context) {
    final int messageLength = message.text.length;
    final double maxWidth = MediaQuery.of(context).size.width * 0.85;
    final double minWidth = 165;
    if (message.type != MessageType.text) return maxWidth;
    final double width = messageLength * 12.0;
    if (width <= minWidth) return minWidth;
    if (width >= maxWidth) return maxWidth;

    return width;
  }

  Widget _getMessageContent() {
    if (message.type == MessageType.text) {
      return Text(
        this.message.text,
        style: TextStyle(
          fontSize: 15,
          fontStyle:
              this.message.isDeleted ? FontStyle.italic : FontStyle.normal,
        ),
      );
    } else if (message.type == MessageType.photo) {
      return CachedNetworkImage(imageUrl: message.text);
    } else if (message.type == MessageType.video) {
      return CustomVideoPlayer.fromUrl(message.text);
    } else
      return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    chatScreenAppBarProvider = Provider.of<ChatScreenAppBarProvider>(context);
    senderIsMe = user.id == message.senderId;
    return GestureDetector(
      child: Column(
        crossAxisAlignment:
            senderIsMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            width: this._getCardWidth(context),
            margin: EdgeInsets.symmetric(vertical: 2.5),
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: this.senderIsMe
                  ? ThemeHandler.myMessageCardColor(context)
                  : ThemeHandler.contactMessageCardColor(context),
              borderRadius: this.senderIsMe
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
              crossAxisAlignment: this.senderIsMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                this._getMessageContent(),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: this.senderIsMe
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      this.message.displayTime,
                      style: Theme
                          .of(context)
                          .textTheme
                          .subtitle2,
                    ),
                    this.senderIsMe ? SizedBox(width: 10.0) : SizedBox.shrink(),
                    this.senderIsMe
                        ? Icon(
                      this.message.isRead
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
