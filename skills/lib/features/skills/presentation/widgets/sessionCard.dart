import 'package:flutter/material.dart';

import '../../domain/entities/session.dart';

class SessionCard extends StatefulWidget {
  Session session;

  SessionCard({Key key, @required this.session}) : super(key: key);

  @override
  _SessionCardState createState() => _SessionCardState(session);
}

class _SessionCardState extends State<SessionCard> {
  Session session;
  _SessionCardState(this.session);
  @override
  void initState() {
    super.initState();
  }

  String get headerString {
    String fromString = session.startTime.format(context);

    String timeString = createTimeString(session.duration);
    return '$fromString, $timeString';
  }

  List events = [
    'Segovia scales - Segovia',
    'Bouree in E minor. J.S. Bach',
    'Gigue - John Dowland',
    'Anji - Davey Graham/Paul Simon'
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber[300],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: GestureDetector(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _headingBuilder(),
                _eventsSectionBuilder(events),
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

  Row _headingBuilder() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          headerString,
          style: Theme.of(context).textTheme.body2,
        ),
        InkWell(
          child: Icon(Icons.check_circle_outline, color: Colors.grey),
          onTap: () {
            _markSessionComplete();
          },
        )
      ],
    );
  }

  Widget _footerBuilder(TimeOfDay time) {
    String endString = time.format(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 2, 2, 2),
      child: Row(
        children: <Widget>[
          Text(
            endString,
            style: Theme.of(context).textTheme.body2,
          ),
        ],
      ),
    );
  }

  Row _eventsSectionBuilder(List events) {
    List<Widget> rows = [];
    for (var event in events) {
      var text = Text(event, style: Theme.of(context).textTheme.body2);
      var timeText = Text('45 min', style: Theme.of(context).textTheme.body2);
      var newRow = Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 2, 2),
          child: Row(
            children: <Widget>[text, timeText],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ));

      rows.add(newRow);
    }
    var eventsColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
    return Row(
      children: <Widget>[eventsColumn],
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
