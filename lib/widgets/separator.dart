import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  final String text;

  Separator(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
      padding: EdgeInsets.all(5),
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 5,
            offset: Offset(1, 1),
          )
        ],
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(48, 207, 208, 0.5),
            Color.fromRGBO(164, 14, 176, 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        this.text,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
