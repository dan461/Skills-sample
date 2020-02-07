import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skills/core/tickTock.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';

class DayCell extends StatefulWidget {
  final DateTime date;
  final List events;

  const DayCell({Key key, this.date, this.events}) : super(key: key);
  @override
  _DayCellState createState() => _DayCellState(date, events);
}

class _DayCellState extends State<DayCell> {
  final DateTime date;
  final List events;

  _DayCellState(this.date, this.events);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 40,
          child: Center(
              child: Text(DateFormat.yMMMMd().format(date),
                  style: Theme.of(context).textTheme.subtitle)),
        ),
        Expanded(
            child: HoursScrollView(
          events: events,
        ))
      ],
    );
  }
}

class HoursScrollView extends StatelessWidget {
  final List events;

  const HoursScrollView({Key key, this.events}) : super(key: key);

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
              // color: Colors.cyan[100],
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
              margin: EdgeInsets.only(left: 6, top: 0),
              height: height,
              decoration: BoxDecoration(
                  // color: Colors.amber[100],
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
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, children: hours),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double cellHeight =
        (MediaQuery.of(context).size.height / 8).floor().toDouble();
    return SingleChildScrollView(
      child: Stack(children: _contentBuilder(cellHeight)),
    );
  }

  List<Widget> _contentBuilder(double cellHeight) {
    List<Widget> children = [];
    children.add(_hoursBuilder(cellHeight));
    for (var event in events) {
      children.add(_eventBuilder(event, cellHeight));
    }

    return children;
  }

  Positioned _eventBuilder(Map event, double cellHeight) {
    Session session = event['session'];
    double yPos = TickTock.timeToDouble(session.startTime) * cellHeight;
    double eventHeight = (cellHeight / 60) * session.duration.toDouble();

    return Positioned(top: yPos, left: 55, child: _eventBox(event, cellHeight));
  }

  Container _eventBox(Map event, double cellHeight) {
    Session session = event['session'];
    List events = event['events'];
    double eventHeight = (cellHeight / 60) * session.duration.toDouble();

    List<Row> rows = [_infoRow(event)];
    for (var event in events) {
      rows.add(_activityRow(event));
    }

    return Container(
        height: eventHeight,
        width: 300,
        color: Colors.blue[200],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
          child: Column(children: rows),
        ));
  }

  Row _infoRow(Map event) {
    Session session = event['session'];
    List events = event['events'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('${session.duration}min'),
        Text('${session.timeRemaining}min open'),
        Text('${events.length} activities'),
      ],
    );
  }

  Row _activityRow(SkillEvent event) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('${event.skillString}'),
        Text('${event.duration} min.')
      ],
    );
  }
}
