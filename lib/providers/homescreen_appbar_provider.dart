import 'package:flutter/cupertino.dart';

class HomeScreenAppBarProvider extends ChangeNotifier {
  String contactId;
  bool contactIsSelected = false;
  bool contactIsFavorite;

  void selectContact({List<String> favoriteContactIds, String contactId}) {
    this.contactId = contactId;
    this.contactIsSelected = true;
    this.contactIsFavorite = favoriteContactIds.contains(contactId);
    notifyListeners();
  }

  void unSelectContact() {
    this.contactId = null;
    this.contactIsSelected = false;
    this.contactIsFavorite = null;
    notifyListeners();
  }
}
