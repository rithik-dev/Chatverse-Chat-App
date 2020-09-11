import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/widgets/recent_chat_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RecentChats extends StatelessWidget {
  User user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Container(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return RecentChatCard(friend: user.friends[index]);
            },
            itemCount: user.friends.length,
          ),
        ),
      ),
    );
  }
}
