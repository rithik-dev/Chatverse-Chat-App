import 'package:chatverse_chat_app/controllers/user_controller.dart';
import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/drawer_provider.dart';
import 'package:chatverse_chat_app/providers/homescreen_appbar_provider.dart';
import 'package:chatverse_chat_app/providers/loading_screen_provider.dart';
import 'package:chatverse_chat_app/services/firebase_storage_service.dart';
import 'package:chatverse_chat_app/views/search_contacts_screen.dart';
import 'package:chatverse_chat_app/widgets/custom_drawer.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:chatverse_chat_app/widgets/favorite_contacts.dart';
import 'package:chatverse_chat_app/widgets/no_contacts_added.dart';
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
        child: Consumer3<User, HomeScreenAppBarProvider, LoadingScreenProvider>(
            builder: (context, user, homeScreenAppBarProvider, loadingProvider,
                snapshot) {
          return CustomLoadingScreen(
            child: Scaffold(
              appBar: this._buildAppBar(
                context,
                homeScreenAppBarProvider,
                loadingProvider,
                user,
              ),
              body: StreamBuilder<QuerySnapshot>(
                stream: FirebaseStorageService.getAllUsersStream(),
                builder: (context, snapshot) {
                  //FIXME: new contacts not updating when added
                  Map<String, String> myContacts = user.contacts;

                  if (snapshot.hasData) {
                    List<Contact> contacts = [];
                    List<Contact> favoriteContacts = [];
                    for (DocumentSnapshot userSnapshot in snapshot.data.docs) {
                      final Contact contact =
                          Contact.fromDocumentSnapshot(userSnapshot);
                      if (myContacts.keys.contains(userSnapshot.id)) {
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

//                      return RecentChats(contactsStream: contactsStream);

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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // no contacts added
                              if (myContacts.keys.length == 0)
                                NoContactsAdded()
                              else ...[
                                FavoriteContacts(
                                  favoriteContactsStream:
                                      favoriteContactsStream,
                                  removeAllFavoriteContactsCallback: () async {
                                    Navigator.pop(context);
                                    loadingProvider.startLoading();
                                    await UserController
                                        .removeContactFromFavorites(
                                      user.favoriteContactIds,
                                    );
                                    loadingProvider.stopLoading();
                                    homeScreenAppBarProvider.unSelectContact();
                                    user.favoriteContactIds.clear();
                                    user.updateUserInProvider(user);
                                  },
                                ),
                                SizedBox(height: 10),
                                RecentChats(contactsStream: contactsStream),
                              ]
                            ],
                          ),
                        ),
                      ],
                    );
                  } else
                    return CustomLoader();
                },
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () {
                  homeScreenAppBarProvider.unSelectContact();
                  Navigator.pushNamed(context, SearchContactsScreen.id);
                },
              ),
            ),
          );
        }),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context,
      HomeScreenAppBarProvider homeScreenAppBarProvider,
      LoadingScreenProvider loadingProvider,
      User user) {
    return AppBar(
      centerTitle: false,
      title: Text("Chatverse"),
      leading: AnimatedCrossFade(
        firstChild: IconButton(
          padding: EdgeInsets.only(top: 10),
          icon: Icon(Icons.menu),
          onPressed: () {
            Provider.of<DrawerProvider>(context, listen: false).toggle();
          },
        ),
        secondChild: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            homeScreenAppBarProvider.unSelectContact();
          },
        ),
        duration: Duration(milliseconds: 250),
        crossFadeState: homeScreenAppBarProvider.contactIsSelected
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
      ),
      actions: [
        if (homeScreenAppBarProvider.contactIsSelected) ...[
          homeScreenAppBarProvider.contactIsFavorite
              ? IconButton(
            icon: Icon(Icons.favorite),
            color: Colors.red,
            onPressed: () async {
              loadingProvider.startLoading();
              await UserController.removeContactFromFavorites(
                  [homeScreenAppBarProvider.contactId]);
              user.favoriteContactIds
                  .remove(homeScreenAppBarProvider.contactId);
              homeScreenAppBarProvider.unSelectContact();
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
                  homeScreenAppBarProvider.contactId);
              user.favoriteContactIds
                  .add(homeScreenAppBarProvider.contactId);
              homeScreenAppBarProvider.unSelectContact();
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
    );
  }
}
