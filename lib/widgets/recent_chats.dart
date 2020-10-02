import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/widgets/recent_chat_card.dart';
import 'package:chatverse_chat_app/widgets/recent_chat_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RecentChats extends StatelessWidget {
  User user;

  final Stream<List<Contact>> contactsStream;

  RecentChats({this.contactsStream});

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return StreamBuilder<List<Contact>>(
      stream: contactsStream,
      builder: (context, contactStreamSnapshot) {
        return Expanded(
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            separatorBuilder: (context, index) {
              return Divider(
                height: 4,
                color: Colors.grey,
              );
            },
            itemBuilder: (context, index) {
              return contactStreamSnapshot.hasData
                  ? RecentChatCard(
                      contact: contactStreamSnapshot.data[index],
                    )
                  : RecentChatCardShimmer();
            },
            itemCount: contactStreamSnapshot.hasData
                ? contactStreamSnapshot.data.length
                : user.contacts.keys.length,
          ),
        );
      },
    );
  }
}
