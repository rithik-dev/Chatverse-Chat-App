import 'package:chatverse_chat_app/models/message.dart';
import 'package:chatverse_chat_app/utilities/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatScreenAppBarProvider extends ChangeNotifier {
  bool messageIsSelected = false;
  Message message;

  void selectMessage({Message message}) {
    this.message = message;
    this.messageIsSelected = true;
    print(
        "selected message : ${this.message.text} index ${this.message.index}");
    notifyListeners();
  }

  void copySelectedMessage() {
    if (this.message == null) return;
    Functions.copyToClipboard(this.message.text);
    Fluttertoast.showToast(
      msg: "Message Copied",
      gravity: ToastGravity.CENTER,
    );
    this.unSelectMessage();
  }

  void unSelectMessage() {
    this.message = null;
    this.messageIsSelected = false;
    notifyListeners();
  }
}
