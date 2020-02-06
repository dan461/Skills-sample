import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayCell extends StatefulWidget {
  final DateTime date;

  const DayCell({Key key, this.date}) : super(key: key);
  @override
  _DayCellState createState() => _DayCellState();
}

class _DayCellState extends State<DayCell> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 40,
          child: Center(
              child: Text(DateFormat.yMMMMd().format(widget.date),
                  style: Theme.of(context).textTheme.subtitle)),
        ),
        Expanded(child: HoursScrollView())
      ],
    );
  }
}

class HoursScrollView extends StatelessWidget {
  TimeOfDay start = TimeOfDay(hour: 13, minute: 30);


  String _hourString(int hour) {
    switch (hour) {
      case 0:
        return '12';
        break;
      case 12:
        return 'NOON';
        break;

      default:
        return hour <= 11 ? hour.toString() : (hour - 12).toString();
    }
    // if (hour == 0)
    //   return '12';

    // else
    //   return hour <= 11 ? hour.toString() : (hour - 12).toString();
  }

  Container _hoursBuilder(double height) {
    List<Row> hours = [];
    for (int hour = 0; hour < 25; hour++) {
      String hourString = _hourString(hour);
      String amPm = hour <= 11 ? 'AM' : 'PM';
      amPm = hour == 12 ? '' : amPm;
      // String timeString = hour == 12 ? 'NOON' : '$hourString$amPm';

      Row hourBox = Row(
        children: <Widget>[
          Container(
            color: Colors.cyan[100],
            width: 40,
              height: height,
              alignment: Alignment.topCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$hourString',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$amPm',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              )),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 6, top: 6),
              height: height,
              decoration: BoxDecoration(
                color: Colors.amber[100],
                  border: Border(
                      top: BorderSide(width: 0.0, color: Colors.grey[400]))),
            ),
          ),
        ],
      );
      hours.add(hourBox);
    }

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, children: hours),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double cellHeight = MediaQuery.of(context).size.height / 12;
    return SingleChildScrollView(
      child: Stack(children: <Widget>[
        _hoursBuilder(cellHeight),
        Positioned(
          top: ((cellHeight * 4.25) + 12) * 1.1,
          left: 55,
          child: Container(
            height: 60,
            width: 200,
            color: Colors.red,
          ),
        )
      ]),
    );
  }
}
