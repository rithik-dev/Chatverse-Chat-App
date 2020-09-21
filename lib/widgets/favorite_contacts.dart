import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/providers/appbar_provider.dart';
import 'package:chatverse_chat_app/utilities/theme_handler.dart';
import 'package:chatverse_chat_app/views/chat_screen.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:chatverse_chat_app/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FavoriteContacts extends StatelessWidget {
  final Stream<List<Contact>> favoriteContactsStream;

  FavoriteContacts({this.favoriteContactsStream});

  @override
  Widget build(BuildContext context) {
    return Consumer2<User, AppBarProvider>(
        builder: (context, user, appBarProvider, snapshot) {
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
                    icon: Icon(
                      Icons.more_horiz,
                    ),
                    iconSize: 30.0,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Container(
              height: 100.0,
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
                          width: 100,
                          child: Column(
                            children: <Widget>[
                              ProfilePicture(
                                favoriteContactsSnapshot.data[index].photoUrl,
                                radius: 35,
                                onPressed: () {
                                  if (appBarProvider
                                      .contactIsSelected) if (appBarProvider
                                          .contactId ==
                                      favoriteContactsSnapshot.data[index].id)
                                    appBarProvider.unSelectContact();
                                    else
                                      appBarProvider.selectContact(
                                        contactId: favoriteContactsSnapshot
                                            .data[index].id,
                                        favoriteContactIds:
                                        user.favoriteContactIds,
                                      );
                                  else
                                    Navigator.pushNamed(context, ChatScreen.id,
                                        arguments: favoriteContactsSnapshot
                                            .data[index]);
                                },
                                onLongPress: () async {
                                  if (appBarProvider.contactIsSelected)
                                    appBarProvider.unSelectContact();
                                  else
                                    appBarProvider.selectContact(
                                      contactId: favoriteContactsSnapshot
                                          .data[index].id,
                                      favoriteContactIds:
                                      user.favoriteContactIds,
                                    );
                                },
                                onVerticalDragStart: (details) {
                                  if (appBarProvider.contactIsSelected)
                                    appBarProvider.unSelectContact();
                                },
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                favoriteContactsSnapshot.data[index].name,
                                maxLines: 1,
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
}
