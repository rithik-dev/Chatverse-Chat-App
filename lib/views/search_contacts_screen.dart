import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:chatverse_chat_app/widgets/search_contacts_searchbar.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchContactsScreen extends StatelessWidget {
  static const id = 'search_contacts_screen';
  final Stream<List<Contact>> allContacts;

  SearchContactsScreen({@required this.allContacts});

  String _searchText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Contacts"),
      ),
      body: Column(
        children: [
          SearchContactsSearchBar(
            onChanged: (String value) {
              this._searchText = value;
            },
          ),
          StreamBuilder<List<Contact>>(
            stream: this.allContacts,
            builder: (context, contactsSnapshot) {
              if (contactsSnapshot.hasData) {
                return Container(
                  child: Text("search results here"),
                );
              } else
                return CustomLoader();
            },
          ),
        ],
      ),
    );
  }
}
