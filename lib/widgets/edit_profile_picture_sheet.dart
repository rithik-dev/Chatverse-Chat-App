import 'dart:io';

import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/loading_screen_provider.dart';
import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:chatverse_chat_app/services/image_cropper_service.dart';
import 'package:chatverse_chat_app/utilities/constants.dart';
import 'package:chatverse_chat_app/utilities/functions.dart';
import 'package:chatverse_chat_app/utilities/theme_handler.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfilePictureBottomSheet extends StatefulWidget {
  createState() => _EditProfilePictureBottomSheetState();
}

class _EditProfilePictureBottomSheetState
    extends State<EditProfilePictureBottomSheet> {
  /// Active image file
  File _imageFile;

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<User, LoadingScreenProvider>(
        builder: (context, user, loadingProvider, snapshot) {
      return CustomLoadingScreen(
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: RaisedButton.icon(
                    padding: EdgeInsets.all(5),
                    icon: Icon(
                      Icons.photo_camera,
                      size: 30,
                    ),
                    label: Text("Camera"),
                    onPressed: () => _pickImage(ImageSource.camera),
                    color: ThemeHandler.unreadMessageBackgroundColor(context),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: RaisedButton.icon(
                    padding: EdgeInsets.all(5),
                    icon: Icon(
                      Icons.photo_library,
                      size: 30,
                    ),
                    label: Text("Gallery"),
                    onPressed: () => _pickImage(ImageSource.gallery),
                    color: ThemeHandler.unreadMessageBackgroundColor(context),
                  ),
                ),
                SizedBox(width: 5),
                Builder(
                  builder: (context) {
                    return Expanded(
                      child: RaisedButton.icon(
                        padding: EdgeInsets.all(5),
                        icon: Icon(
                          Icons.delete,
                          size: 30,
                        ),
                        label: Text("Delete"),
                        onPressed: () async {
                          if (user.photoUrl != kDefaultPhotoUrl) {
                            loadingProvider.startLoading();
                            final String newUrl = await FirebaseStorageService
                                .removeProfilePicture(
                              userId: user.id,
                              oldImageURL: user.photoUrl,
                            );
                            loadingProvider.stopLoading();
                            user.photoUrl = newUrl;
                            user.updateUserInProvider(user);
                            Navigator.pop(context);
                          } else {
                            Functions.showSnackBar(
                              context,
                              "Profile Picture is already removed !",
                            );
                          }
                        },
                        color:
                            ThemeHandler.unreadMessageBackgroundColor(context),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (_imageFile != null) ...[
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 130),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: FileImage(_imageFile),
                      fit: BoxFit.fill,
                    ),
                  ),
                  height: 150,
//                  width: 200,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton.icon(
                      icon: Icon(Icons.crop),
                      label: Text("Crop"),
                      onPressed: () async {
                        _imageFile = await ImageCropperService.cropImage(
                            image: _imageFile);
                        setState(() {});
                      },
                    ),
                    RaisedButton.icon(
                      icon: Icon(Icons.refresh),
                      label: Text("Clear image"),
                      onPressed: _clear,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: RaisedButton.icon(
                    color: Colors.blue,
                    label: Text('Upload'),
                    icon: Icon(Icons.cloud_upload),
                    onPressed: () async {
                      loadingProvider.startLoading();
                      final String newUrl =
                          await FirebaseStorageService.updateProfilePicture(
                        userId: user.id,
                        oldImageURL: user.photoUrl,
                        newImage: _imageFile,
                      );
                      loadingProvider.stopLoading();
                      user.photoUrl = newUrl;
                      user.updateUserInProvider(user);
                      Navigator.pop(context);
                    },
                  ),
                )
              ] else ...[
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Please select an image",
                      style: Theme.of(context).textTheme.headline4,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ),
                ),
                Spacer(),
                Icon(Icons.forum, size: 100),
                SizedBox(height: 100),
              ]
            ],
          ),
        ),
      );
    });
  }
}
