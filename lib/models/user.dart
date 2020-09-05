import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  String name;
  String email;
  String profilePicURL;
  String userId;

  User({
    @required this.name,
    @required this.email,
    @required this.profilePicURL,
    @required this.userId,
  });
}
