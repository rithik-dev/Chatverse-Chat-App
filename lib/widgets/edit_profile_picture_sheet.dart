import 'dart:io';

import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/loading_screen_provider.dart';
import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:chatverse_chat_app/utilities/constants.dart';
import 'package:chatverse_chat_app/utilities/functions.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfilePictureBottomSheet extends StatefulWidget {
  createState() => _EditProfilePictureBottomSheetState();
}

class _EditProfilePictureBottomSheetState
    extends State<EditProfilePictureBottomSheet> {
  /// Active image file
  File _imageFile;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));

    setState(() {
      _imageFile = croppedFile ?? _imageFile;
    });
  }

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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton.icon(
                  icon: Icon(
                    Icons.photo_camera,
                    size: 30,
                  ),
                  label: Text("Camera"),
                  onPressed: () => _pickImage(ImageSource.camera),
                  color: Colors.blue.withOpacity(0.6),
                ),
                RaisedButton.icon(
                  icon: Icon(
                    Icons.photo_library,
                    size: 30,
                  ),
                  label: Text("Gallery"),
                  onPressed: () => _pickImage(ImageSource.gallery),
                  color: Colors.pink.withOpacity(0.6),
                ),
                Builder(builder: (context) {
                  return RaisedButton.icon(
                    icon: Icon(
                      Icons.delete,
                      size: 30,
                    ),
                    label: Text("Delete"),
                    onPressed: () async {
                      if (user.photoUrl != kDefaultPhotoUrl) {
                        loadingProvider.startLoading();
                        final String newUrl =
                            await FirebaseStorageService.removeProfilePicture(
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
                    color: Colors.red.withOpacity(0.7),
                  );
                }),
              ],
            ),
          ),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              if (_imageFile != null) ...[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Image.file(_imageFile),
                  height: 225,
                  width: 225,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton.icon(
                      icon: Icon(Icons.crop),
                      label: Text("Crop"),
                      onPressed: _cropImage,
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
                SizedBox(height: 100),
                Center(
                  child: Text(
                    "Please select an image",
                  ),
                ),
                SizedBox(height: 100),
                Icon(Icons.forum, size: 50),
              ]
            ],
          ),
        ),
      );
    });
  }
}