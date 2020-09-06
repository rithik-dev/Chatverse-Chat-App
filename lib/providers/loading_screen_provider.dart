import 'package:flutter/cupertino.dart';

class LoadingScreenProvider extends ChangeNotifier {
  bool isLoading = false;

  void startLoading() {
    this.isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    this.isLoading = false;
    notifyListeners();
  }
}
