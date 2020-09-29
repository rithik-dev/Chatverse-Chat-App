import 'package:chatverse_chat_app/controllers/user_controller.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/loading_screen_provider.dart';
import 'package:chatverse_chat_app/widgets/bottom_sheet_clipper.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:chatverse_chat_app/widgets/edit_profile_picture_sheet.dart';
import 'package:chatverse_chat_app/widgets/edit_profile_text_field.dart';
import 'package:chatverse_chat_app/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  static const id = 'profile_screen';
  String _name;
  String _email;

  @override
  Widget build(BuildContext context) {
    return Consumer2<User, LoadingScreenProvider>(
        builder: (context, user, loadingProvider, child) {
      return SafeArea(
        child: CustomLoadingScreen(
          child: Scaffold(
            body: Column(
              children: [
                SizedBox(height: 20),
                _ProfilePicture(user.photoUrl),
                SizedBox(height: 20),
                EditProfileTextField(
                  prefixIcon: Icons.person,
                  onChanged: (String name) {
                    this._name = name;
                  },
                  defaultValue: user.name,
                  onEditPressed: () async {
                    if (this._name != null &&
                        this._name.trim() != "" &&
                        this._name != user.name) {
                      loadingProvider.startLoading();
                      await UserController.updateName(this._name);
                      user.name = this._name;
                      user.updateUserInProvider(user);
                      loadingProvider.stopLoading();
                    }
                  },
                ),
                EditProfileTextField(
                  prefixIcon: Icons.email,
                  onChanged: (String email) {
                    this._email = email;
                  },
                  defaultValue: user.email,
                  onEditPressed: () {
                    print("edit ${this._email}");
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _ProfilePicture extends StatelessWidget {
  final String photoUrl;

  _ProfilePicture(this.photoUrl);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ProfilePicture(this.photoUrl, borderWidth: 2),
        Positioned(
          right: 0,
          bottom: 0,
          child: CircleAvatar(
            backgroundColor: Colors.black,
            radius: 15,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              icon: Icon(
                Icons.edit,
                size: 18,
                color: Colors.white,
              ),
              onPressed: () {
                showModalBottomSheet(
                  shape: BottomSheetClipper(),
                  backgroundColor:
                  Theme
                      .of(context)
                      .colorScheme
                      .secondary
                      .withOpacity(0.8),
                  context: context,
                  builder: (context) => EditProfilePictureBottomSheet(),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
