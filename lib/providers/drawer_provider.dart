import 'package:flutter/cupertino.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class DrawerProvider {
  final GlobalKey<InnerDrawerState> innerDrawerKey =
      GlobalKey<InnerDrawerState>();

  void toggle() {
    innerDrawerKey.currentState.toggle(direction: InnerDrawerDirection.start);
  }
}
