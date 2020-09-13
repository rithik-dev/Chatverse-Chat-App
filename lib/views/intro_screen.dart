import 'package:chatverse_chat_app/views/authentication_screen.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  static const id = 'intro_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: FlatButton(
            child: Text(
              "GO",
              style: Theme.of(context).textTheme.headline4,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AuthenticationPage.id);
            },
          ),
        ),
      ),
    );
  }
}
