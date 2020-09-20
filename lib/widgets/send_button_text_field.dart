import 'package:chatverse_chat_app/utilities/theme_handler.dart';
import 'package:flutter/material.dart';

class SendButtonTextField extends StatelessWidget {
  final VoidCallback onSend;
  final Function(String) onChanged;
  final TextEditingController controller;

  SendButtonTextField({
    @required this.onSend,
    @required this.onChanged,
    @required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      height: 70.0,
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: ThemeHandler.sendTextFieldBackgroundColor(context),
              ),
              child: TextField(
                controller: this.controller,
                textCapitalization: TextCapitalization.sentences,
                textAlignVertical: TextAlignVertical.center,
                onChanged: this.onChanged,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Send a message ...",
                  border: InputBorder.none,
                  prefixIcon: IconButton(
                    icon: Icon(Icons.attach_file),
                    iconSize: 25.0,
                    onPressed: () {},
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    iconSize: 25.0,
                    onPressed: this.onSend,
                  ),
                ),
                style: TextStyle(),
              ),
            ),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            radius: 28,
            backgroundColor: ThemeHandler.sendTextFieldBackgroundColor(context),
            child: IconButton(
              icon: Icon(Icons.mic_none),
              iconSize: 30,
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
