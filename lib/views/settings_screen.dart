import 'package:chatverse_chat_app/utilities/theme_handler.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const id = 'settings_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text(
              'settings',
              style: Theme.of(context).textTheme.headline4,
            ),
            FlatButton(
              onPressed: () async {
                await ThemeHandler.toggleTheme(context);
              },
              child: Text("toggle theme"),
            )
          ],
        ),
      ),
    );
  }
}
