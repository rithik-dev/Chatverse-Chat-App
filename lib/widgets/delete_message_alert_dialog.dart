import 'package:flutter/material.dart';

class DeleteMessageAlertDialog extends StatelessWidget {
  final VoidCallback deleteForMeCallback;
  final VoidCallback deleteForEveryoneCallback;

  DeleteMessageAlertDialog({
    @required this.deleteForMeCallback,
    @required this.deleteForEveryoneCallback,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text("Delete Message ?"),
      content: Container(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FlatButton(
              child: Text("DELETE FOR ME"),
              onPressed: this.deleteForMeCallback,
            ),
            FlatButton(
              child: Text("DELETE FOR EVERYONE"),
              onPressed: this.deleteForEveryoneCallback,
            ),
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
