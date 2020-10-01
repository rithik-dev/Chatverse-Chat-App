import 'dart:io';

import 'package:chatverse_chat_app/controllers/message_controller.dart';
import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/message.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/loading_screen_provider.dart';
import 'package:chatverse_chat_app/services/image_cropper_service.dart';
import 'package:chatverse_chat_app/utilities/theme_handler.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:chatverse_chat_app/widgets/custom_video_player.dart';
import 'package:chatverse_chat_app/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddAttachment extends StatefulWidget {
  static const id = 'add_attachment';
  final Contact contact;
  final String profilePicHeroTag;

  AddAttachment({
    @required this.contact,
    @required this.profilePicHeroTag,
  });

  @override
  _AddAttachmentState createState() => _AddAttachmentState();
}

class _AddAttachmentState extends State<AddAttachment>
    with SingleTickerProviderStateMixin {
  File _selectedGalleryImage;
  File _selectedCameraImage;
  File _selectedGalleryVideo;
  File _selectedCameraVideo;
  MessageType messageType;
  TabController _tabController;
  bool _mediaIsSelected = false;
  LoadingScreenProvider loadingProvider;
  User user;

  @override
  void initState() {
    this._tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    this._tabController.dispose();
    if (this._mediaIsSelected) {
      try {
        this._selectedCameraImage.delete();
        this._selectedGalleryImage.delete();
        this._selectedCameraVideo.delete();
        this._selectedGalleryVideo.delete();
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    loadingProvider = Provider.of<LoadingScreenProvider>(context);
    return SafeArea(
      child: CustomLoadingScreen(
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                (this._mediaIsSelected && this.messageType == MessageType.photo)
                    ? FloatingActionButton(
                        heroTag: null,
                        onPressed: () async {
                          if (this._tabController.index == 0) {
                            this._selectedGalleryImage =
                                await ImageCropperService.cropImage(
                                    image: this._selectedGalleryImage);
                          } else {
                            this._selectedCameraImage =
                                await ImageCropperService.cropImage(
                                    image: this._selectedCameraImage);
                          }
                          setState(() {});
                        },
                        child: Icon(Icons.crop),
                      )
                    : SizedBox.shrink(),
                this._mediaIsSelected
                    ? FloatingActionButton(
                        heroTag: null,
                        onPressed: () async {
                          File _uploadFile;
                          MessageType _messageType;
                          if (this._selectedGalleryImage != null) {
                            _uploadFile = this._selectedGalleryImage;
                            _messageType = MessageType.photo;
                          }

                          if (this._selectedCameraImage != null) {
                            _uploadFile = this._selectedCameraImage;
                            _messageType = MessageType.photo;
                          }

                          if (this._selectedCameraVideo != null) {
                            _uploadFile = this._selectedCameraVideo;
                            _messageType = MessageType.video;
                          }

                          if (this._selectedGalleryVideo != null) {
                            _uploadFile = this._selectedGalleryVideo;
                            _messageType = MessageType.video;
                          }

                          try {
                            loadingProvider.startLoading();
                            await MessageController.sendMediaMessage(
                              contactId: this.widget.contact.id,
                              file: _uploadFile,
                              messageType: _messageType,
                              chatRoomId: this.widget.contact.chatRoomId,
                              senderId: user.id,
                            );
                            loadingProvider.stopLoading();
                          } catch (e) {} finally {
                            loadingProvider.stopLoading();
                            Navigator.pop(context);
                          }
                        },
                        child: Icon(Icons.send),
                      )
                    : SizedBox.shrink()
              ],
            ),
          ),
          appBar: AppBar(
            title: Text("Add Attachment"),
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Hero(
                  tag: this.widget.profilePicHeroTag,
                  child: ProfilePicture(
                    this.widget.contact.photoUrl,
                    radius: 23,
                  ),
                ),
              )
            ],
          ),
          body: Column(
            children: [
              TabBar(
                controller: this._tabController,
                unselectedLabelColor: Colors.white,
                labelColor: Theme.of(context).accentColor,
                tabs: [
                  Tab(
                    icon: Icon(Icons.photo),
                    text: "Gallery",
                  ),
                  Tab(
                    icon: Icon(Icons.camera),
                    text: "Camera",
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  controller: this._tabController,
                  children: [
                    (this._selectedGalleryImage == null &&
                            this._selectedGalleryVideo == null)
                        ? this._noMediaSelected(
                            title:
                                "Please select a photo or a video from gallery",
                          )
                        : this._showFile(),
                    (this._selectedCameraImage == null &&
                            this._selectedCameraVideo == null)
                        ? this._noMediaSelected(
                            title:
                                "Please select a photo or a video from camera",
                          )
                        : this._showFile(),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: RaisedButton.icon(
                    icon: Icon(Icons.photo),
                    padding: EdgeInsets.all(10),
                    label: Text("PHOTO"),
                    color: ThemeHandler.unreadMessageBackgroundColor(context),
                    onPressed: () async {
                      setState(() => messageType = MessageType.photo);
                      await this._selectMedia();
                    }),
              ),
              SizedBox(width: 5),
              Expanded(
                child: RaisedButton.icon(
                  padding: EdgeInsets.all(10),
                  icon: Icon(Icons.videocam),
                  label: Text("VIDEO"),
                  color: ThemeHandler.unreadMessageBackgroundColor(context),
                  onPressed: () async {
                    setState(() => messageType = MessageType.video);
                    await this._selectMedia();
                  },
                ),
              ),
              if (this._mediaIsSelected) ...[
                SizedBox(width: 5),
                Expanded(
                  child: RaisedButton.icon(
                    padding: EdgeInsets.all(10),
                    icon: Icon(Icons.cancel),
                    label: Text("CLEAR"),
                    color: ThemeHandler.unreadMessageBackgroundColor(context),
                    onPressed: () {
                      setState(() {
                        this._selectedGalleryImage = null;
                        this._selectedCameraImage = null;
                        this._selectedCameraVideo = null;
                        this._selectedGalleryVideo = null;
                        this._mediaIsSelected = false;
                      });
                    },
                  ),
                ),
              ] else
                SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  Widget _showFile() {
    return (this.messageType == MessageType.photo)
        ? Image.file(
            this._tabController.index == 0
                ? this._selectedGalleryImage
                : this._selectedCameraImage,
          )
        : this._tabController.index == 0
            ? CustomVideoPlayer.fromFile(this._selectedGalleryVideo)
            : CustomVideoPlayer.fromFile(this._selectedCameraVideo);
  }

  ImageSource get source {
    return (this._tabController.index == 0)
        ? ImageSource.gallery
        : ImageSource.camera;
  }

  Future<void> _selectMedia() async {
    this._selectedCameraImage = null;
    this._selectedCameraVideo = null;
    this._selectedGalleryImage = null;
    this._selectedGalleryVideo = null;

    if (this._tabController.index == 0) {
      if (messageType == MessageType.video)
        this._selectedGalleryVideo =
            await ImagePicker.pickVideo(source: this.source);
      else
        this._selectedGalleryImage =
            await ImagePicker.pickImage(source: this.source);
    } else {
      if (messageType == MessageType.video)
        this._selectedCameraVideo =
            await ImagePicker.pickVideo(source: this.source);
      else
        this._selectedCameraImage =
            await ImagePicker.pickImage(source: this.source);
    }

    // if no image is selected after pressing photo/video
    if (this._selectedCameraVideo != null ||
        this._selectedCameraImage != null ||
        this._selectedGalleryVideo != null ||
        this._selectedGalleryImage != null)
      this._mediaIsSelected = true;
    else
      this._mediaIsSelected = false;

    setState(() {});
  }

  Widget _noMediaSelected({String title}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Icon(Icons.forum, size: 100),
      ],
    );
  }
}
