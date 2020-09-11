import 'package:chatverse_chat_app/controllers/user_controller.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/views/authentication_screen.dart';
import 'package:chatverse_chat_app/widgets/category_selector.dart';
import 'package:chatverse_chat_app/widgets/favorite_contacts.dart';
import 'package:chatverse_chat_app/widgets/recent_chats.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  static const id = 'home_screen';
  User user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          leading: Icon(Icons.menu),
          actions: [
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () async {
                await UserController.logoutUser();
                Navigator.pushReplacementNamed(context, AuthenticationPage.id);
              },
            )
          ],
        ),
        body: Column(
          children: [
            CategorySelector(
              categories: ['Messages', 'Online', 'Groups', 'Requests'],
              onChanged: (int index) {
                print(index);
              },
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    FavoriteContacts(favoriteFriends: user.friends),
                    RecentChats(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
