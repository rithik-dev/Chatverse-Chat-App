import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/message.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/chatscreen_appbar_provider.dart';
import 'package:chatverse_chat_app/utilities/theme_handler.dart';
import 'package:chatverse_chat_app/views/full_screen_media_view_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class MessageCard extends StatelessWidget {
  final Message message;
  final Contact contact;
  User user;
  ChatScreenAppBarProvider chatScreenAppBarProvider;

  MessageCard({
    @required this.message,
    @required this.contact,
  });

  bool senderIsMe;

  double _getCardWidth(BuildContext context) {
    final double maxWidth = MediaQuery.of(context).size.width * 0.85;
    if (message.type != MessageType.text && !message.isDeleted) return maxWidth;
    final double minWidth = 165;
    final int messageLength = message.content.length;
    final double width = messageLength * 12.0;
    if (width <= minWidth) return minWidth;
    if (width >= maxWidth) return maxWidth;

    return width;
  }

  Widget _getMessageContent(BuildContext context) {
    if (message.type == MessageType.text || message.isDeleted) {
      return Text(
        this.message.content,
        style: TextStyle(
          fontSize: 15,
          fontStyle:
              this.message.isDeleted ? FontStyle.italic : FontStyle.normal,
        ),
      );
    } else {
      return Hero(
        tag: message.content,
        child: message.type == MessageType.photo
            ? Container(
                height: 300,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: message.content,
                    placeholder: (context, _) => Shimmer.fromColors(
                      child: Container(
                        color: Colors.white,
                        height: 300,
                      ),
                      baseColor: Colors.white,
                      highlightColor: Colors.grey[500],
                    ),
                    errorWidget: (context, _, __) => Container(
                      color: Colors.black,
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Icon(Icons.error, size: 75),
                    ),
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 200,
                width: double.infinity,
                child: Icon(
                  Icons.play_circle_filled,
                  color: Colors.white,
                  size: 75,
                ),
              ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    chatScreenAppBarProvider = Provider.of<ChatScreenAppBarProvider>(context);
    senderIsMe = user.id == message.senderId;
    return GestureDetector(
      onTap: () {
        if (chatScreenAppBarProvider.messageIsSelected) {
          if (chatScreenAppBarProvider.message.index == message.index)
            chatScreenAppBarProvider.unSelectMessage();
          else
            chatScreenAppBarProvider.selectMessage(message: message);
        } else {
          if (message.type == MessageType.photo ||
              message.type == MessageType.video)
            Navigator.pushNamed(
              context,
              FullScreenMediaViewPage.id,
              arguments: {
                'mediaUrl': message.content,
                'messageType': message.type,
                'senderName':
                    message.senderId == user.id ? user.name : this.contact.name,
              },
            );
        }
      },
      onLongPress: () async {
        if (chatScreenAppBarProvider.messageIsSelected)
          chatScreenAppBarProvider.unSelectMessage();
        else
          chatScreenAppBarProvider.selectMessage(message: message);
      },
      child: Container(
        color: (chatScreenAppBarProvider.messageIsSelected &&
                chatScreenAppBarProvider.message.index == message.index)
            ? ThemeHandler.selectedContactBackgroundColor(context)
            : Colors.transparent,
        child: Align(
          alignment: senderIsMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: this._getCardWidth(context),
            margin: EdgeInsets.symmetric(vertical: 2.5),
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            decoration: BoxDecoration(
//              color: this.senderIsMe
//                  ? ThemeHandler.myMessageCardColor(context)
//                  : ThemeHandler.contactMessageCardColor(context),
              gradient: LinearGradient(
                begin:
                    this.senderIsMe ? Alignment.bottomLeft : Alignment.topLeft,
                colors: [
                  if (this.senderIsMe) ...[
                    Color.fromRGBO(164, 14, 176, 0.5),
                    Color.fromRGBO(254, 101, 101, 0.7),
                  ] else ...[
                    Color.fromRGBO(51, 8, 103, 0.6),
                    Color.fromRGBO(48, 207, 208, 0.4),
                  ],
                ],
              ),
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
                this._getMessageContent(context),
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
        ),
      ),
    );
  }
}
