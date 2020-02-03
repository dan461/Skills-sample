import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skills/features/skills/domain/entities/session.dart';

typedef DayCellTapCallback(DateTime date);

class DayOfWeekCell extends StatefulWidget {
  final DateTime date;
  final List<Session> sessions;
  final DayCellTapCallback tapCallback;

  const DayOfWeekCell({Key key, this.date, this.tapCallback, this.sessions})
      : super(key: key);

  @override
  _DayOfWeekCellState createState() =>
      _DayOfWeekCellState(date, sessions, tapCallback);
}

class _DayOfWeekCellState extends State<DayOfWeekCell> {
  final DateTime date;
  final List<Session> sessions;
  final DayCellTapCallback tapCallback;

  _DayOfWeekCellState(this.date, this.sessions, this.tapCallback);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.0, color: Colors.grey[400]))),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _content(widget.date, sessions),
          ),
        ),
      ),
    );
  }

  List<Widget> _content(DateTime date, List<Session> sessions) {
    List<Widget> widgets = [];
    widgets.add(_dateBoxBuilder(date));

    for (var session in sessions) {
      widgets.add(_sessionBoxBuilder(session));
      // widgets.add(_sessionBoxBuilder(session));
      // widgets.add(_sessionBoxBuilder(session));
      // widgets.add(_sessionBoxBuilder(session));
      // widgets.add(_sessionBoxBuilder(session));
    }

    return widgets;
  }

  Container _dateBoxBuilder(DateTime date) {
    return Container(
      color: Colors.grey[200],
      margin: EdgeInsets.all(2),
      width: 60,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(DateFormat.E().format(widget.date)),
            Text(DateFormat.d().format(widget.date)),
          ],
        ),
      ),
    );
  }

  Container _sessionBoxBuilder(Session session) {
    return Container(
        padding: EdgeInsets.only(left: 2, right: 6),
        margin: EdgeInsets.all(2),
        color: Colors.amber[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(session.startTime.format(context),
                    style: Theme.of(context).textTheme.body2)
              ],
            ),
            Text('${session.duration} min', style: Theme.of(context).textTheme.body1),
            Text('4 actvities', style: Theme.of(context).textTheme.body1),
            Text('${session.timeRemaining} min. open', style: Theme.of(context).textTheme.body1)
          ],
        ));
  }
}
