import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skills/core/tickTock.dart';

import 'calendar.dart';

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
    double cellHeight =
        (MediaQuery.of(context).size.height / 8).floor().toDouble();
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
          cellHeight: cellHeight,
        ))
      ],
    );
  }
}

class HoursScrollView extends StatefulWidget {
  final List events;
  final double cellHeight;

  const HoursScrollView({Key key, this.events, this.cellHeight})
      : super(key: key);

  @override
  _HoursScrollViewState createState() =>
      _HoursScrollViewState(events, cellHeight);
}

class _HoursScrollViewState extends State<HoursScrollView> {
  final List events;
  final double cellHeight;
  ScrollController scrollController;

  _HoursScrollViewState(this.events, this.cellHeight);

  @override
  initState() {
    super.initState();

    double start = 0;
    if (events.isNotEmpty) {
      start = TickTock.timeToDouble(events.first.startTime);
    }
    double yPos = start * cellHeight;
    scrollController =
        ScrollController(initialScrollOffset: yPos, keepScrollOffset: false);
  }

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
  }

  Text _hourText(int hour) {
    String hourString = _hourString(hour);
    double fontSize = hour == 12 ? 12 : 14;
    return Text(
      '$hourString',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
    );
  }

  Container _hoursBuilder(double height) {
    List<Row> hours = [];
    for (int hour = 0; hour < 25; hour++) {
      String amPm = hour <= 11 ? 'AM' : 'PM';
      amPm = hour == 12 ? '' : amPm;

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
                  _hourText(hour),
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
    return SingleChildScrollView(
      controller: scrollController,
      child: Stack(children: _contentBuilder(cellHeight)),
    );
  }

  List<Widget> _contentBuilder(double cellHeight) {
    List<Widget> children = [];
    children.add(_hoursBuilder(cellHeight));
    for (var event in widget.events) {
      children.add(_eventBuilder(event, cellHeight));
    }

    return children;
  }

  // add an event view for each event (Session.eventView)
  Positioned _eventBuilder(CalendarEvent event, double cellHeight) {
    // Session session = event['session'];
    double yPos = TickTock.timeToDouble(event.startTime) * cellHeight;
    if (event == widget.events.first) {}

    return Positioned(top: yPos, left: 55, child: _eventBox(event, cellHeight));
  }

  // make a Container with a child that is the session.eventView
  Container _eventBox(CalendarEvent event, double cellHeight) {
    double eventHeight = (cellHeight / 60) * event.duration.toDouble();

    return Container(
        height: eventHeight,
        width: 300,
        color: Colors.blue[200],
        child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
            child: event.eventView));
  }
}
