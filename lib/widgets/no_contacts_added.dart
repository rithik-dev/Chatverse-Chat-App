import 'package:flutter/material.dart';

class NoContactsAdded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(10),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.forum,
            size: 100,
          ),
          Text(
            "No contacts added .. ",
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(
            "Start by adding a contact by clicking on the search icon .. ",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}
