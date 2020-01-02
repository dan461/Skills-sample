import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';

import '../../domain/entities/session.dart';

class SessionCard extends StatefulWidget {
  Map<String, dynamic> sessionMap;

  SessionCard({Key key, @required this.sessionMap}) : super(key: key);

  @override
  _SessionCardState createState() => _SessionCardState(sessionMap);
}

class _SessionCardState extends State<SessionCard> {
  Map<String, dynamic> sessionMap;
  _SessionCardState(this.sessionMap);
  @override
  void initState() {
    super.initState();
  }

  String get headerString {
    String fromString = sessionMap['session'].startTime.format(context);

    String timeString = createTimeString(sessionMap['session'].duration);
    return '$fromString, $timeString';
  }

  // List events = [
  //   'Segovia scales - Segovia',
  //   'Bouree in E minor. J.S. Bach',
  //   'Gigue - John Dowland',
  //   'Anji - Davey Graham/Paul Simon'
  // ];

  @override
  Widget build(BuildContext context) {
    var session = sessionMap['session'];
    List<SkillEvent> events = sessionMap['events'];

    return Card(
      color: Colors.amber[300],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: GestureDetector(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 8, 0),
            child: Column(
              children: <Widget>[
                _headerBuilder(session.startTime, events.length, session.duration),
                _eventsSectionBuilder(sessionMap['events']),
                _footerBuilder(session.endTime)
              ],
            ),
          ),
        ),
        onTap: () {
          _showSessionDetails();
        },
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

  Row _headerBuilder(TimeOfDay startTime, int count, int duration) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          startTime.format(context),
          style: Theme.of(context).textTheme.body1,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Text(
            '$duration min.'
          ),
        ),
        Text(
          '$count events',
          style: Theme.of(context).textTheme.body2,
        ),
        // InkWell(
        //   child: Icon(Icons.check_circle_outline, color: Colors.grey),
        //   onTap: () {
        //     _markSessionComplete();
        //   },
        // )
      ],
    );
  }

  Row _footerBuilder(TimeOfDay endTime) {
    return Row(
      children: <Widget>[
        Text(
          endTime.format(context),
          style: Theme.of(context).textTheme.body1,
        ),
      ],
    );
  }

  Row _eventsSectionBuilder(List<SkillEvent> events) {
    List<Widget> rows = [];
    for (var event in events) {
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ));

      rows.add(newRow);
    }
    var eventsColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: rows,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 50,
        ),
        eventsColumn,
      ],
    );
  }

  void _markSessionComplete() {}
  void _showSessionDetails() {}

  // List<Widget> _contentBuilder() {
  //   // take in list of strings? (for test) descriptions of skills
  //   // create a Text() for each string, add each Text() to a list - textsList

  //   List<Widget> rows = [];
  //   List skills = [
  //     'Segovia scales - Segovia',
  //     'Bouree in E minor. J.S. Bach',
  //     'Gigue - John Dowland',
  //     'Anji - Davey Graham/Paul Simon'
  //   ];
  //   var header = Padding(
  //     padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
  //     child: _headingBuilder(),
  //   );

  //   rows.add(header);

  //   for (var skill in skills) {
  //     var text = Text(skill, style: Theme.of(context).textTheme.body2);
  //     var timeText = Text('45 min', style: Theme.of(context).textTheme.body2);
  //     var newRow = Padding(
  //         padding: const EdgeInsets.fromLTRB(10, 0, 2, 2),
  //         child: Row(
  //           children: <Widget>[text, timeText],
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         ));

  //     rows.add(newRow);
  //   }

  //   rows.add(_footerBuilder(session.endTime));

  //   return rows;
  // }

}
