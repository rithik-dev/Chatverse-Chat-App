import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatverse_chat_app/models/message.dart';
import 'package:chatverse_chat_app/widgets/custom_video_player.dart';
import 'package:flutter/material.dart';

class FullScreenMediaViewPage extends StatelessWidget {
  static const id = 'full_screen_media_view_page';
  final String url;
  final String senderName;
  final MessageType messageType;

  FullScreenMediaViewPage({
    @required this.url,
    @required this.senderName,
    @required this.messageType,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(this.senderName),
          centerTitle: false,
          actions: [
            Icon(Icons.forward),
            SizedBox(width: 20),
            Icon(Icons.more_vert),
          ],
        ),
        body: Hero(
          tag: this.url,
          child: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: this.messageType == MessageType.photo
                  ? CachedNetworkImage(imageUrl: this.url)
                  : CustomVideoPlayer.fromUrl(this.url),
            ),
          ),
        ),
      ),
    );
  }
}
