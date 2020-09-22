import 'package:chatverse_chat_app/controllers/user_controller.dart';
import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/utilities/exceptions.dart';
import 'package:chatverse_chat_app/utilities/theme_handler.dart';
import 'package:chatverse_chat_app/views/chat_screen.dart';
import 'package:chatverse_chat_app/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SearchContactCard extends StatelessWidget {
  final Contact contact;
  User user;

  SearchContactCard({this.contact});

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return InkWell(
      onTap: () async {
        try {
          final Map<String, String> newContact =
              await UserController.addContact(contact.id);
          user.contacts.addAll(newContact);
          user.updateUserInProvider(user);
          contact.chatRoomId = newContact[contact.id];
          Navigator.pushReplacementNamed(
            context,
            ChatScreen.id,
            arguments: contact,
          );
        } on CannotAddContactException catch (e) {
          Fluttertoast.showToast(
            msg: "An error occurred while adding contact",
            gravity: ToastGravity.TOP,
            toastLength: Toast.LENGTH_LONG,
          );
        } catch (e) {
          Fluttertoast.showToast(
            msg: "An error occurred while adding contact",
            gravity: ToastGravity.TOP,
            toastLength: Toast.LENGTH_LONG,
          );
        }
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ThemeHandler.unreadMessageBackgroundColor(context),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ProfilePicture(
              this.contact.photoUrl,
              radius: 35,
              borderWidth: 2,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this.contact.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    this.contact.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
