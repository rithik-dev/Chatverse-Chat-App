import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/homescreen_appbar_provider.dart';
import 'package:chatverse_chat_app/utilities/theme_handler.dart';
import 'package:chatverse_chat_app/views/chat_screen.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:chatverse_chat_app/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FavoriteContacts extends StatelessWidget {
  final Stream<List<Contact>> favoriteContactsStream;
  final VoidCallback removeAllFavoriteContactsCallback;

  FavoriteContacts({
    this.favoriteContactsStream,
    this.removeAllFavoriteContactsCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<User, HomeScreenAppBarProvider>(
        builder: (context, user, homeScreenAppBarProvider, snapshot) {
      return Container(
        height: user.favoriteContactIds.length == 0 ? 0 : 170,
        decoration: BoxDecoration(
          color: ThemeHandler.favoriteContactsBackgroundColor(context),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Favorite Contacts',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    iconSize: 30.0,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            title: Text("Favorite Contacts"),
                            content: RaisedButton.icon(
                              color: Colors.transparent,
                              padding: EdgeInsets.all(10),
                              icon: Icon(Icons.remove_circle),
                              label: Text("Remove all favorites"),
                              onPressed: this.removeAllFavoriteContactsCallback,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 100.0,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: StreamBuilder<List<Contact>>(
                stream: favoriteContactsStream,
                builder: (context, favoriteContactsSnapshot) {
                  if (favoriteContactsSnapshot.hasData) {
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: favoriteContactsSnapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 110,
                          child: Column(
                            children: <Widget>[
                              Hero(
                                tag: favoriteContactsSnapshot.data[index].id +
                                    "-favorite",
                                child: this._buildProfilePicture(
                                  favoriteContactsSnapshot,
                                  index,
                                  homeScreenAppBarProvider,
                                  user,
                                  context,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                favoriteContactsSnapshot.data[index].name,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else
                    return CustomLoader();
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  ProfilePicture _buildProfilePicture(
      AsyncSnapshot<List<Contact>> favoriteContactsSnapshot,
      int index,
      HomeScreenAppBarProvider homeScreenAppBarProvider,
      User user,
      BuildContext context) {
    return ProfilePicture(
      favoriteContactsSnapshot.data[index].photoUrl,
      radius: 35,
      onPressed: () {
        if (homeScreenAppBarProvider
            .contactIsSelected) if (homeScreenAppBarProvider
                .contactId ==
            favoriteContactsSnapshot.data[index].id)
          homeScreenAppBarProvider.unSelectContact();
        else
          homeScreenAppBarProvider.selectContact(
            contactId: favoriteContactsSnapshot.data[index].id,
            favoriteContactIds: user.favoriteContactIds,
          );
        else
          Navigator.pushNamed(context, ChatScreen.id, arguments: {
            'contact': favoriteContactsSnapshot.data[index],
            'profilePicHeroTag':
                favoriteContactsSnapshot.data[index].id + "-favorite"
          });
      },
      onLongPress: () async {
        if (homeScreenAppBarProvider.contactIsSelected)
          homeScreenAppBarProvider.unSelectContact();
        else
          homeScreenAppBarProvider.selectContact(
            contactId: favoriteContactsSnapshot.data[index].id,
            favoriteContactIds: user.favoriteContactIds,
          );
      },
      onVerticalDragStart: (details) {
        if (homeScreenAppBarProvider.contactIsSelected)
          homeScreenAppBarProvider.unSelectContact();
      },
    );
  }
}
