import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/drawer_provider.dart';
import 'package:chatverse_chat_app/views/profile_screen.dart';
import 'package:chatverse_chat_app/views/settings_screen.dart';
import 'package:chatverse_chat_app/widgets/bottom_sheet_clipper.dart';
import 'package:chatverse_chat_app/widgets/profile_picture.dart';
import 'package:chatverse_chat_app/widgets/sign_out_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:provider/provider.dart';

final List<Color> gradientColors = [Color(0xFFFB9245), Color(0xFFF54E6B)];

class CustomDrawer extends StatelessWidget {
  final Scaffold scaffold;

  CustomDrawer({
    @required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
    return InnerDrawer(
      key: Provider.of<DrawerProvider>(context).innerDrawerKey,
      onTapClose: true,
      swipe: true,
      backgroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      colorTransitionScaffold: Colors.black38,
      scale: IDOffset.horizontal(0.85),
      proportionalChildArea: true,
      borderRadius: 30,
      leftAnimationType: InnerDrawerAnimation.static,
      rightAnimationType: InnerDrawerAnimation.quadratic,
      leftChild: _LeftChild(),
      scaffold: this.scaffold,
    );
  }
}

// ignore: must_be_immutable
class _LeftChild extends StatelessWidget {
  User user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              height: 225,
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  ProfilePicture(user.photoUrl, radius: 65),
                  SizedBox(height: 15),
                  Expanded(
                    child: Text(
                      user.name,
                      style: Theme.of(context).textTheme.headline1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                DrawerItem(
                  icon: Icons.person,
                  title: "My Profile",
                  onPressed: () async {
                    Navigator.pushNamed(context, ProfileScreen.id);
                  },
                ),
                DrawerItem(
                  icon: Icons.settings,
                  title: "Settings",
                  onPressed: () async {
                    Navigator.pushNamed(context, SettingsScreen.id);
                  },
                ),
                DrawerItem(
                  icon: Icons.exit_to_app,
                  title: "Sign Out",
                  onPressed: () async {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      shape: BottomSheetClipper(),
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.8),
                      context: context,
                      builder: (context) => SignOutBottomSheet(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  DrawerItem({
    @required this.icon,
    @required this.title,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              offset: Offset(1, 1),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(this.icon, size: 35, color: Colors.black),
            SizedBox(width: 20),
            Text(
              this.title,
              style: Theme
                  .of(context)
                  .textTheme
                  .headline2,
            ),
          ],
        ),
      ),
    );
  }
}
