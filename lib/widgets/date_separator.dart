import 'package:flutter/material.dart';

class DateSeparator extends StatelessWidget {
  final String date;

  DateSeparator(this.date);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 90, vertical: 10),
      padding: EdgeInsets.all(5),
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.lightBlue,
      ),
      child: Text(
        this.date,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
