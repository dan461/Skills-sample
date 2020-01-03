import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';

import '../../domain/entities/session.dart';
import 'dayDetails.dart';

class SessionCard extends StatefulWidget {
  final Map<String, dynamic> sessionMap;
  final ShowSessionEditorCallback editorCallback;

  SessionCard(
      {Key key, @required this.sessionMap, @required this.editorCallback})
      : super(key: key);

  @override
  _SessionCardState createState() =>
      _SessionCardState(sessionMap, editorCallback);
}

class _SessionCardState extends State<SessionCard> {
  Map<String, dynamic> sessionMap;
  final ShowSessionEditorCallback editorCallback;
  _SessionCardState(this.sessionMap, this.editorCallback);

  // TODO - should probably get this value somewhere else, maybe add to Session entity
  int openTime = 0;
  @override
  void initState() {
    super.initState();
  }

  String get headerString {
    String fromString = sessionMap['session'].startTime.format(context);

    String timeString = createTimeString(sessionMap['session'].duration);
    return '$fromString, $timeString';
  }

  @override
  Widget build(BuildContext context) {
    Session session = sessionMap['session'];
    List<SkillEvent> events = sessionMap['events'];
    openTime = session.duration;
    for (var event in events) {
      openTime -= event.duration;
    }

    return GestureDetector(
      onTap: () {
        editorCallback(session);
      },
      child: Card(
        color: Colors.amber[300],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  _timeSection(session.startTime, session.endTime),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _middleSectionBuilder(events)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          child: Icon(
                            Icons.check_circle_outline,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onTap: () {
                            _markSessionComplete();
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String createTimeString(int time) {
    String timeString;

    String hours;
    String min;
    if (time < 60) {
      min = time.toString();
      timeString = '$min minutes';
    } else if (time == 60) {
      timeString = '1 hour';
    } else {
      hours = (time / 60).floor().toString();
      timeString = '$hours hrs';
      if (time % 60 != 0) {
        min = (time % 60).toString();
        timeString = '$hours hrs $min min';
      }
    }

    return timeString;
  }

  Row _headerBuilder(int count, int duration) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Text('$duration min.'),
        ),
        Text(
          '$openTime min. open',
          style: Theme.of(context).textTheme.body2,
        ),
      ],
    );
  }

  Container _timeSection(TimeOfDay startTime, TimeOfDay endTime) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 1, 4, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              startTime.format(context),
              style: Theme.of(context).textTheme.body1,
            ),
            Text(
              endTime.format(context),
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _middleSectionBuilder(List<SkillEvent> events) {
    List<Widget> rows = [];
    rows.add(
      _headerBuilder(events.length, 60),
    );
    if (events.isEmpty) {
      Row emptyRow = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(height: 30, child: Text('No events')),
        ],
      );
      rows.add(emptyRow);
    } else {
      for (var event in events) {
        // create row for event
        var text =
            Text(event.skillString, style: Theme.of(context).textTheme.body2);
        var timeText = Text('45 min', style: Theme.of(context).textTheme.body2);
        var newRow = Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 2, 2),
            child: Row(
              children: <Widget>[
                text,
                SizedBox(
                  width: 40,
                ),
                timeText
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ));

        rows.add(newRow);
      }
      Row emptyRow = Row(
        children: <Widget>[
          Container(
            height: 10,
            color: Colors.red,
          ),
        ],
      );
      rows.add(emptyRow);
    }

    return rows;
  }

  void _markSessionComplete() {}
}
