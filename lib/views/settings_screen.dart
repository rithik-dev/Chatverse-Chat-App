import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const id = 'settings_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text(
            'settings',
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
      ),
    );
  }
}
