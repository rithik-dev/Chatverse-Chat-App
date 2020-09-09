import 'package:chatverse_chat_app/views/recent_chats_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RecentChatsScreen(),
    );
  }
}
