import 'package:chatverse_chat_app/controllers/user_controller.dart';
import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/drawer_provider.dart';
import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:chatverse_chat_app/widgets/category_selector.dart';
import 'package:chatverse_chat_app/widgets/custom_drawer.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:chatverse_chat_app/widgets/favorite_contacts.dart';
import 'package:chatverse_chat_app/widgets/recent_chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  static const id = 'home_screen';
  User user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return SafeArea(
      child: CustomDrawer(
        scaffold: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Provider.of<DrawerProvider>(context, listen: false).toggle();
              },
            ),
            elevation: 0,
            actions: [
//              IconButton(
//                icon: Icon(Icons.contacts, color: Colors.white),
//                iconSize: 25,
//                onPressed: () async {
//                  // TODO: open new page and show all users
//                  // TODO: update in provider
//                  // TODO: add refresh indicator
//                final Contact contact =
//                    await UserController.addContact(contactId);
//                user.contacts.add(contact);
//                user.chatRoomIds.add(contact.chatRoomId);
//                user.updateUserInProvider(user);
//                },
//              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              final User updatedUser = await UserController.getUser(user.id);
              user.updateUserInProvider(updatedUser);
            },
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseStorageService.getAllUsersStream(),
              builder: (context, snapshot) {
                Map<String, String> myContacts = user.contacts;

                if (snapshot.hasData) {
                  List<Contact> contacts = [];
                  List<Contact> favoriteContacts = [];
                  for (DocumentSnapshot userSnapshot in snapshot.data.docs) {
                    if (myContacts.keys.contains(userSnapshot.id)) {
                      final Contact contact =
                          Contact.fromDocumentSnapshot(userSnapshot);
                      contact.chatRoomId = myContacts[userSnapshot.id];
                      contacts.add(contact);
                      if (user.favoriteContactIds.contains(userSnapshot.id))
                        favoriteContacts.add(contact);
                    }
                  }

                  Stream<List<Contact>> contactsStream = Stream.value(contacts);
                  Stream<List<Contact>> favoriteContactsStream =
                      Stream.value(favoriteContacts);

                  return Column(
                    children: [
                      CategorySelector(
                        categories: [
                          'Messages',
                          'Online',
                          'Groups',
                          'Requests'
                        ],
                        onChanged: (int index) {
                          print(index);
                        },
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              FavoriteContacts(
                                  favoriteContactsStream:
                                      favoriteContactsStream),
                              RecentChats(contactsStream: contactsStream),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else
                  return CustomLoader();
              },
            ),
          ),
        ),
      ),
    );
  }
}
