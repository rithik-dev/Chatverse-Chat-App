import 'package:chatverse_chat_app/utilities/theme_handler.dart';
import 'package:flutter/material.dart';

class SearchContactsSearchBar extends StatelessWidget {
  final Function(String) onChanged;

  SearchContactsSearchBar({@required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: ThemeHandler.unreadMessageBackgroundColor(context),
      ),
      child: TextField(
        onChanged: this.onChanged,
        autofocus: true,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.search, size: 30, color: Colors.deepOrange),
          ),
          border: InputBorder.none,
          hintText: "Search for contacts",
        ),
      ),
    );
  }
}
