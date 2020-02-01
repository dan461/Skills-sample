import 'package:flutter/material.dart';

class DayOfMonthCell extends StatelessWidget {
  final DateTime date;
  final Function tapCallback;
  final bool hasSession;

  final int displayedMonth;

  DayOfMonthCell({this.date, this.displayedMonth, this.tapCallback, this.hasSession});

  void dayTapped() {
    print(date);
  }

  Widget _indicatorBuilder() {
    Widget widget;
    if (hasSession) {
      widget = Center(
        child: ClipOval(
          child: Material(
            color: Colors.green,
            child: SizedBox(
              width: 10,
              height: 10,
            ),
          ),
        ),
      );
    } else 
      widget = SizedBox(height: 0, width: 0,);
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          tapCallback();
        },
        child: Container(
          // height: cellHeight,
          decoration: BoxDecoration(
            color: date.weekday > 5 ? Colors.grey[100] : Colors.white,
            border: Border(
                top: BorderSide(width: 0.0, color: Colors.grey[200]),
                left: BorderSide.none),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 6, 2, 2),
                    child: Text(
                      date.day.toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: date.month == displayedMonth
                              ? Colors.black
                              : Colors.grey[400]),
                    ),
                  ),
                ],
              ),
              _indicatorBuilder(),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     _indicatorBuilder()
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
