import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:chatverse_chat_app/widgets/search_contact_card.dart';
import 'package:chatverse_chat_app/widgets/search_contacts_searchbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SearchContactsScreen extends StatefulWidget {
  static const id = 'search_contacts_screen';

  @override
  _SearchContactsScreenState createState() => _SearchContactsScreenState();
}

class _SearchContactsScreenState extends State<SearchContactsScreen> {
  List<Contact> _filteredContacts = [];
  User user;
  List<Contact> _contacts;
  String _searchText = "";

  Future<void> _getContacts() async {
    Contact contact;
    QuerySnapshot contactsSnapshot = await FirebaseStorageService.getAllUsers();
    setState(() => this._contacts = []);
    for (QueryDocumentSnapshot snapshot in contactsSnapshot.docs) {
      contact = Contact.fromDocumentSnapshot(snapshot);
      // chatroom id should be null as if it exists, user is already in contacts
      if (contact.id != user.id && !user.contacts.keys.contains(contact.id)) {
        setState(() => this._contacts.add(contact));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    this._getContacts();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return SafeArea(
      child: CustomLoadingScreen(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Search Contacts"),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await this._getContacts();
              this._setFilteredContacts();
            },
            child: Column(
              children: [
                SearchContactsSearchBar(
                  onChanged: (String value) {
                    this._searchText = value?.toLowerCase()?.trim() ?? "";
                    this._setFilteredContacts();
                  },
                ),
                this._contacts == null
                    ? CustomLoader()
                    : NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (overScroll) {
                          overScroll.disallowGlow();
                          return;
                        },
                        child: Expanded(
                          child: (this._searchText == null ||
                                  this._searchText.trim() == "")
                              ? ListView(
                                  children: [
                                    Lottie.asset(
                                        'assets/lottie/no-search-text.json')
                                  ],
                                )
                              : this._filteredContacts.length == 0
                                  ? ListView(
                                      children: [
                                        Lottie.asset(
                                            'assets/lottie/no-search-results.json')
                                      ],
                                    )
                                  : ListView.builder(
                                      itemBuilder: (context, index) {
                                        return SearchContactCard(
                                            contact:
                                                this._filteredContacts[index]);
                                      },
                                      itemCount: this._filteredContacts.length,
                                    ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setFilteredContacts() {
    setState(() => this._filteredContacts = []);

    if (this._searchText != "") {
      for (Contact contact in this._contacts) {
        if (contact.name.toLowerCase().contains(this._searchText) ||
            contact.email.toLowerCase().contains(this._searchText)) {
          setState(() {
            this._filteredContacts.add(contact);
          });
        }
      }
    }
  }
}
