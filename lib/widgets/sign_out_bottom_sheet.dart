import 'package:chatverse_chat_app/controllers/user_controller.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/views/authentication_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void openSignOutDrawer(BuildContext context) {
  User user;
  showModalBottomSheet(
    shape: _BottomSheetShape(),
    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
    context: context,
    builder: (context) {
      user = Provider.of<User>(context);
      return Container(
        height: 180,
        padding: EdgeInsets.fromLTRB(15, 55, 15, 25),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "${user.name}, are you sure you want to sign out ?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: OutlineButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    borderSide: BorderSide(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "Stay logged in",
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: MaterialButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await UserController.logoutUser();
                      Navigator.pushReplacementNamed(
                          context, AuthenticationPage.id);
                    },
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Text(
                      "Sign out",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

class _BottomSheetShape extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => throw UnimplementedError();

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    throw UnimplementedError();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return getClip(rect.size);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    throw UnimplementedError();
  }

  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 40);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 40);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    return path;
  }
}
