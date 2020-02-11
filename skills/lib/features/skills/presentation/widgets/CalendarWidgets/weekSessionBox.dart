import 'package:flutter/material.dart';

class WeekSessionBox extends StatelessWidget {
  final Map sessionMap;

  const WeekSessionBox({Key key, this.sessionMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var session = sessionMap['session'];
    var events = sessionMap['events'];
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
            Text('${session.duration} min',
                style: Theme.of(context).textTheme.body1),
            Text('${events.length} actvities',
                style: Theme.of(context).textTheme.body1),
            Text('${session.timeRemaining} min. open',
                style: Theme.of(context).textTheme.body1)
          ],
        ));
  }
}
