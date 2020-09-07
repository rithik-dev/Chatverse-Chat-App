import 'package:chatverse_chat_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const id = 'home_screen';

  static List<QueryDocumentSnapshot> contacts = [];
  static List<String> contactIds = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text(Provider.of<User>(context).toString()),
        ),
      ),
    );
  }
}
