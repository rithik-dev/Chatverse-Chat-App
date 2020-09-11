import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/views/chat_screen.dart';
import 'package:chatverse_chat_app/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FavoriteContacts extends StatelessWidget {
  final List<Contact> favoriteContacts;

  FavoriteContacts({@required this.favoriteContacts});

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
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                ),
                iconSize: 30.0,
                color: Colors.blueGrey,
                onPressed: () {},
              ),
            ],
          ),
        ),
        Container(
          height: 110.0,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: favoriteContacts.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ChatScreen.id,
                      arguments: favoriteContacts[index]);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    children: <Widget>[
                      ProfilePicture(favoriteContacts[index].photoUrl,
                          radius: 35),
                      SizedBox(height: 6.0),
                      Text(
                        favoriteContacts[index].name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}