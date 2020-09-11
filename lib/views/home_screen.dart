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
          elevation: 0,
          actions: [
            //TODO: remove login button.. move to app drawer
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () async {
                await UserController.logoutUser();
                Navigator.pushReplacementNamed(context, AuthenticationPage.id);
              },
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: Colors.white),
              iconSize: 30,
              onPressed: () async {
                // TODO: open new page and show all users
                // TODO: update in provider
                // TODO: add refresh indicator
//                final Contact contact =
//                    await UserController.addContact(contactId);
//                user.contacts.add(contact);
//                user.chatRoomIds.add(contact.chatRoomId);
//                user.updateUserInProvider(user);
              },
            ),
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
                    FavoriteContacts(favoriteContacts: user.contacts),
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
