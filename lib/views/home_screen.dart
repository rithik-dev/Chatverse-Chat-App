import 'package:chatverse_chat_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const id = 'home_screen';

  User user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text("HOME ${user.toString()}"),
        ),
      ),
    );
  }
}
