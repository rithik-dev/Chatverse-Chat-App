import 'package:chatverse_chat_app/models/contact.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/widgets/custom_loading_screen.dart';
import 'package:chatverse_chat_app/widgets/recent_chat_card.dart';
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
    return Expanded(
      child: Container(
        decoration: BoxDecoration(),
        child: Container(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowGlow();
              return;
            },
            child: StreamBuilder<List<Contact>>(
              stream: contactsStream,
              builder: (context, contactStreamSnapshot) {
                if (contactStreamSnapshot.hasData) {
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 4,
                        color: Colors.grey,
                      );
                    },
                    itemBuilder: (context, index) {
                      return RecentChatCard(
                        contact: contactStreamSnapshot.data[index],
                      );
                    },
                    itemCount: contactStreamSnapshot.data.length,
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
