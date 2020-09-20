import 'package:flutter/material.dart';

class DateSeparator extends StatelessWidget {
  final String date;

  DateSeparator(this.date);

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
            color: Colors.deepOrangeAccent,
            blurRadius: 5,
            offset: Offset(1, 1),
          )
        ],
        borderRadius: BorderRadius.circular(10),
        color: Colors.deepOrange,
      ),
      child: Text(
        this.date,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
