import 'package:flutter/material.dart';

class DayCell extends StatelessWidget {
  final DateTime date;
  final Function tapCallback;

  final int displayedMonth;

  DayCell({this.date, this.displayedMonth, this.tapCallback});

  void dayTapped() {
    print(date);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          tapCallback(date);
        },
        child: Container(
          // height: cellHeight,
          decoration: BoxDecoration(
            color: date.weekday > 5 ? Colors.grey[100] : Colors.white,
            border: Border(
                top: BorderSide(width: 0.0, color: Colors.grey[400]),
                left: BorderSide(width: 0.0, color: Colors.grey[400])),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              date.day.toString(),
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: date.month == displayedMonth
                      ? Colors.black
                      : Colors.grey[400]),
            ),
          ),
        ),
      ),
    );
  }
}
