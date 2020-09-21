import 'package:chatverse_chat_app/controllers/user_controller.dart';
import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/appbar_provider.dart';
import 'package:chatverse_chat_app/providers/drawer_provider.dart';
import 'package:chatverse_chat_app/providers/loading_screen_provider.dart';
import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:chatverse_chat_app/widgets/custom_drawer.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:chatverse_chat_app/widgets/favorite_contacts.dart';
import 'package:chatverse_chat_app/widgets/recent_chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomDrawer(
        child: Consumer3<User, AppBarProvider, LoadingScreenProvider>(builder:
            (context, user, appBarProvider, loadingProvider, snapshot) {
          return CustomLoadingScreen(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(75),
                child: AppBar(
                  leading: AnimatedCrossFade(
                    firstChild: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        Provider.of<DrawerProvider>(context, listen: false)
                            .toggle();
                      },
                    ),
                    secondChild: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        appBarProvider.unSelectContact();
                      },
                    ),
                    duration: Duration(milliseconds: 250),
                    crossFadeState: appBarProvider.contactIsSelected
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                  ),
                  actions: [
                    if (appBarProvider.contactIsSelected) ...[
                      appBarProvider.contactIsFavorite
                          ? IconButton(
                              icon: Icon(Icons.favorite),
                              color: Colors.red,
                              onPressed: () async {
                                loadingProvider.startLoading();
                                await UserController.removeContactFromFavorites(
                                    appBarProvider.contactId);
                                user.favoriteContactIds
                                    .remove(appBarProvider.contactId);
                                appBarProvider.unSelectContact();
                                user.updateUserInProvider(user);
                                loadingProvider.stopLoading();
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.favorite_border),
                              color: Colors.red,
                              onPressed: () async {
                                loadingProvider.startLoading();
                                await UserController.addContactToFavorites(
                                    appBarProvider.contactId);
                                user.favoriteContactIds
                                    .add(appBarProvider.contactId);
                                appBarProvider.unSelectContact();
                                user.updateUserInProvider(user);
                                loadingProvider.stopLoading();
                              },
                            ),
                      IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {},
                      ),
                    ]
                  ],
                ),
              ),
              body: StreamBuilder<QuerySnapshot>(
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

                    Stream<List<Contact>> contactsStream =
                        Stream.value(contacts);
                    Stream<List<Contact>> favoriteContactsStream =
                        Stream.value(favoriteContacts);

                    return Column(
                      children: [
//                          CategorySelector(
//                            categories: [
//                              'Messages',
//                              'Online',
//                              'Groups',
//                              'Requests'
//                            ],
//                            onChanged: (int index) {
//                              print(index);
//                            },
//                          ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                                FavoriteContacts(
                                    favoriteContactsStream:
                                        favoriteContactsStream),
                                SizedBox(height: 10),
                              RecentChats(contactsStream: contactsStream),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else
                    return CustomLoader();
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
