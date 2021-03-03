import 'package:flutter/material.dart';
import 'package:skills/core/stringConstants.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';

import 'notesFormField.dart';

typedef AddEventCallback(int eventDuration, Skill skill, String notesString);
typedef CancelEventCreateCallback();

class EventCreator extends StatefulWidget {
  final Map<String, dynamic> eventMap;
  final AddEventCallback addEventCallback;
  final CancelEventCreateCallback cancelEventCreateCallback;

  const EventCreator(
      {Key key,
      @required this.eventMap,
      @required this.addEventCallback,
      @required this.cancelEventCreateCallback})
      : super(key: key);
  @override
  _EventCreatorState createState() => _EventCreatorState(
      this.eventMap, this.addEventCallback, this.cancelEventCreateCallback);
}

class _EventCreatorState extends State<EventCreator> {
  final Map<String, dynamic> eventMap;
  final AddEventCallback addEventCallback;
  final CancelEventCreateCallback cancelEventCreateCallback;
  Skill _selectedSkill;
  Goal _currentGoal;
  String _goalText;

  TextEditingController _eventDurationTextControl = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  bool _addButtonEnabled = false;

  _EventCreatorState(
      this.eventMap, this.addEventCallback, this.cancelEventCreateCallback);

  @override
  initState() {
    super.initState();
    _selectedSkill = eventMap['skill'];
    _currentGoal = eventMap['goal'];
    _goalText = _currentGoal != null ? _currentGoal.goalText : "No goal";
  }

  @override
  dispose() {
    super.dispose();
    _selectedSkill = null;
    _currentGoal = null;
  }

  int get _eventDuration {
    int minutes = _eventDurationTextControl.text.isNotEmpty
        ? int.parse(_eventDurationTextControl.text)
        : 0;
    return minutes;
  }

  void _setAddButtonEnabled() {
    setState(() {
      _addButtonEnabled = _eventDuration >= 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Container(
        width: MediaQuery.of(context).size.width - 10,
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'New Event',
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(_selectedSkill.name,
                    style: Theme.of(context).textTheme.subtitle1),
                Container(
                  // color: Colors.amber,
                  height: 30,
                  width: 100,
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Minutes: ',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          controller: _eventDurationTextControl,
                          onChanged: (_) {
                            _setAddButtonEnabled();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[Text(_goalText)],
            ),
            NotesFormField(_notesController, NOTES),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonBar(
                  buttonHeight: 30,
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        cancelEventCreateCallback();
                      },
                    ),
                    RaisedButton(
                        child: Text('Add'),
                        onPressed: _addButtonEnabled
                            ? () {
                                addEventCallback(_eventDuration, _selectedSkill,
                                    _notesController.text);
                              }
                            : null),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
