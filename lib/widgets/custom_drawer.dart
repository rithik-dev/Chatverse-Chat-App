import 'package:chatverse_chat_app/controllers/user_controller.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/drawer_provider.dart';
import 'package:chatverse_chat_app/views/authentication_screen.dart';
import 'package:chatverse_chat_app/views/edit_profile_screen.dart';
import 'package:chatverse_chat_app/views/settings_screen.dart';
import 'package:chatverse_chat_app/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:provider/provider.dart';

final Color backgroundColor = Colors.lightBlueAccent;
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
      scale: IDOffset.horizontal(0.8),
      proportionalChildArea: true,
      borderRadius: 30,
      leftAnimationType: InnerDrawerAnimation.static,
      rightAnimationType: InnerDrawerAnimation.quadratic,
      leftChild: _leftChild(),
      scaffold: this.scaffold,
    );
  }
}

// ignore: camel_case_types, must_be_immutable
class _leftChild extends StatelessWidget {
  User user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                ProfilePicture(user.photoUrl, radius: 65),
                SizedBox(height: 20),
                Expanded(
                  child: Text(
                    user.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
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
                  Navigator.pushNamed(context, EditProfileScreen.id);
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
                  await UserController.logoutUser();
                  Navigator.pushReplacementNamed(
                      context, AuthenticationPage.id);
                },
              ),
            ],
          ),
        ],
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: 225,
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
      child: ListTile(
        title: Text(
          this.title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        leading: Icon(this.icon, size: 35, color: Colors.black),
        onTap: this.onPressed,
      ),
    );
  }
}
