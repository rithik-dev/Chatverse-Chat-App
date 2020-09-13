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
      height: 60.0,
      color: Colors.white,
      alignment: Alignment.center,
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
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            onPressed: () {},
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            onPressed: this.onSend,
          ),
        ),
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
