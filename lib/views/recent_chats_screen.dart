import 'package:chatverse_chat_app/controllers/user_controller.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/views/authentication_screen.dart';
import 'package:chatverse_chat_app/widgets/recent_chat_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RecentChatsScreen extends StatelessWidget {
  User user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
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
      backgroundColor: Colors.grey[300],
      body: Column(
        children: user.friends.map((e) => RecentChatCard(friend: e)).toList(),
      ),
    );
  }
}
