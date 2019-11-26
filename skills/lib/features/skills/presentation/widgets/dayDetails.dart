import 'package:flutter/material.dart';
import 'package:skills/features/skills/presentation/pages/sessionEditorScreen.dart';

class DayDetails extends StatefulWidget {
  @override
  _DayDetailsState createState() => _DayDetailsState();
}

class _DayDetailsState extends State<DayDetails> {
  bool hasSession = false;

  @override
  void initState() {
    super.initState();
  }

  void _addSession() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SessionEditor();
    }));
  }

  Widget _showContentForSession() {
    if (hasSession) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return SessionCard();
        },
        itemCount: 3,
      );
    } else {
      return Container(
        child: Center(
          child: RaisedButton(
            child: Text('Add a Session'),
            onPressed: () {
              _addSession();
            },
          ),
        ),
      );
    }
  }

// TODO - needs date and session count
  Container _headerBuilder() {
    return Container(
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Nov. 22, 2019',
              style: Theme.of(context).textTheme.subhead,
            ),
            Text(
              '2 Sessions',
              style: Theme.of(context).textTheme.subhead,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO test only
    hasSession = false;

    return Column(
      children: <Widget>[
        _headerBuilder(),
        Expanded(child: _showContentForSession())
      ],
    );
  }
}

// SessionCard
class SessionCard extends StatefulWidget {
  @override
  _SessionCardState createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  Row _headingBuilder() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '3 pm to 5pm, 2 hours. 4 skills',
          style: Theme.of(context).textTheme.subhead,
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

  void _markSessionComplete() {}
  void _showSessionDetails() {}

  List<Widget> _contentBuilder() {
    // take in list of strings? (for test) descriptions of skills
    // create a Text() for each string, add each Text() to a list - textsList

    List<Widget> rows = [];
    List skills = [
      'Segovia scales - Segovia',
      'Bouree in E minor. J.S. Bach',
      'Gigue - John Dowland',
      'Anji - Davey Graham/Paul Simon'
    ];
    var pad = Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 8, 6),
      child: _headingBuilder(),
    );

    rows.add(pad);

    for (var skill in skills) {
      var text = Text(skill, style: Theme.of(context).textTheme.body2);
      var timeText = Text('45 min', style: Theme.of(context).textTheme.body2);
      var newRow = Row(
        children: <Widget>[text, timeText],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      );
      rows.add(newRow);
    }

    return rows;
  }

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
              children: _contentBuilder(),
            ),
          ),
        ),
        onTap: () {
          _showSessionDetails();
        },
      ),
    );
  }
}
