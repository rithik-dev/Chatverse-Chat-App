import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/views/chat_screen.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:chatverse_chat_app/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FavoriteContacts extends StatelessWidget {
  final Stream<List<Contact>> favoriteContactsStream;

  FavoriteContacts({this.favoriteContactsStream});

  User user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);

    return Column(
      children: <Widget>[
        SizedBox(height: 5),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Favorite Contacts',
                style: Theme.of(context).textTheme.headline3,
              ),
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                ),
                iconSize: 30.0,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Container(
          height: user.favoriteContactIds.length == 0 ? 0 : 110.0,
          color: Theme.of(context).colorScheme.onPrimary,
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
                      width: 125,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ChatScreen.id,
                              arguments: favoriteContactsSnapshot.data[index]);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            children: <Widget>[
                              ProfilePicture(
                                  favoriteContactsSnapshot.data[index].photoUrl,
                                  radius: 35),
                              SizedBox(height: 6.0),
                              Text(
                                favoriteContactsSnapshot.data[index].name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline4,
                              ),
                            ],
                          ),
                        ),
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
    );
  }
}
