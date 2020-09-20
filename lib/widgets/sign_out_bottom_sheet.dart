import 'package:chatverse_chat_app/controllers/user_controller.dart';
import 'package:chatverse_chat_app/models/user.dart';
import 'package:chatverse_chat_app/views/authentication_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SignOutBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(builder: (context, user, snapshot) {
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
              softWrap: true,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
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
                      color: Colors.lightBlueAccent,
                    ),
                    child: Text(
                      "Stay logged in",
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: MaterialButton(
                    color: Colors.blueAccent,
                    onPressed: () async {
                      Navigator.pop(context);
                      await UserController.logoutUser();
                      Navigator.pushReplacementNamed(
                          context, AuthenticationPage.id);
                      Fluttertoast.showToast(
                        msg: "Signed out successfully !",
                        gravity: ToastGravity.TOP,
                      );
                    },
                    child: Text(
                      "Sign out",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
