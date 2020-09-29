import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final dynamic dataSource;

  CustomVideoPlayer({@required this.dataSource});

  factory CustomVideoPlayer.fromUrl({@required String url}) {
    return CustomVideoPlayer(dataSource: url);
  }

  factory CustomVideoPlayer.fromFile({@required File file}) {
    return CustomVideoPlayer(dataSource: file);
  }

  @override
  State<StatefulWidget> createState() {
    return _CustomVideoPlayerState();
  }
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    if (this.widget.dataSource is String)
      this._videoPlayerController =
          VideoPlayerController.network(this.widget.dataSource as String);
    else if (this.widget.dataSource is File)
      this._videoPlayerController =
          VideoPlayerController.file(this.widget.dataSource as File);

    this._chewieController = ChewieController(
      videoPlayerController: this._videoPlayerController,
      // check this._videoPlayerController.value.size.aspectRatio
      aspectRatio: this._videoPlayerController.value.aspectRatio,
      autoPlay: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.tealAccent,
        handleColor: Colors.lightBlueAccent,
        bufferedColor: Colors.black87,
      ),
      placeholder: Container(color: Colors.black),
      autoInitialize: true,
    );

    setState(() {});
  }

  @override
  void dispose() {
    this._videoPlayerController.dispose();
    this._chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(controller: this._chewieController);
  }
}
