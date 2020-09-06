import 'package:flutter/material.dart';

class Functions {
  Functions._();

  static void showSnackBar(BuildContext context, String text,
      {Duration duration, SnackBarAction action}) {
    if (text == null) return;
    final snackBar = SnackBar(
        content: Text(text),
        duration: duration ?? Duration(seconds: 2),
        action: action);
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
