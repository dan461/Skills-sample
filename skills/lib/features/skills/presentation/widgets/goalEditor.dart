import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/presentation/bloc/goalEditorScreen/goalEditor_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/goalEditorScreen/goalEditor_event.dart';

import '../../../../service_locator.dart';

class GoalEditor extends StatefulWidget {
  @override
  _GoalEditorState createState() => _GoalEditorState();
}

class _GoalEditorState extends State<GoalEditor> {
  GoaleditorBloc _bloc;
  int _goalType;

  bool _doneEnabled;
  String _goalTranslation;

  @override
  void initState() {
    super.initState();
    _bloc = locator<GoaleditorBloc>();
    _goalType = 0;
    _doneEnabled = false;
    _goalTranslation = '';
  }

  TextEditingController _hoursTextController = TextEditingController();
  TextEditingController _minTextController = TextEditingController();
  TextEditingController _goalDescTextController = TextEditingController();

  String get _startDateString {
    return _startDate == null
        ? "Select Date"
        : DateFormat.yMMMd().format(_startDate);
  }

  String get _endDateString {
    return _endDate == null
        ? "Select Date"
        : DateFormat.yMMMd().format(_endDate);
  }

  bool get _isTimeBased {
    return _goalType == 0;
  }

  int get _goalMinutes {
    int minutes = (int.parse(_hoursTextController.text) * 60) +
        int.parse(_minTextController.text);
    return minutes;
  }

  DateTime _startDate;
  DateTime _endDate;

  void _setDoneButtonEnabled() {
    bool timeOrTaskSet;
    if (_isTimeBased)
      timeOrTaskSet = _goalMinutes > 0;
    else
      timeOrTaskSet = _goalDescTextController.text != null;

    _doneEnabled = _startDate != null && _endDate != null && timeOrTaskSet;
  }

  void _insertNewGoal() async {
    Goal newGoal = Goal(
      fromDate: _startDate.millisecondsSinceEpoch,
      toDate: _endDate.millisecondsSinceEpoch,
      isComplete: false,
      timeBased: _isTimeBased,
      goalTime: _goalMinutes,
    );
    _bloc.add(InsertNewGoalEvent(newGoal));
    _goalTranslation = _bloc.translateGoal(newGoal);
  }

  void _selectStartDate() async {
    DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        lastDate: DateTime.now().add(Duration(days: 365)));

    if (pickedDate != null) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  void _selectEndDate() async {
    DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        lastDate: DateTime.now().add(Duration(days: 365)));

    if (pickedDate != null) {
      setState(() {
        _endDate = pickedDate;
      });
    }
  }

  TextField _goalDescriptionField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Goal Description'),
      maxLength: 250,
      maxLines: 4,
      maxLengthEnforced: true,
      keyboardType: TextInputType.text,
      controller: _goalDescTextController,
      onChanged: (_) {
        _setDoneButtonEnabled();
      },
    );
  }

  Widget _goalDetailAreaBuilder() {
    Widget area;
    if (_isTimeBased)
      area = _goalTimeSelectionArea();
    else
      area = _goalDescriptionField();

    return area;
  }

  Row _goalTimeSelectionArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          width: 100,
          child: Row(
            children: <Widget>[
              Text(
                'Hours: ',
                style: Theme.of(context).textTheme.subhead,
              ),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(hintText: '00', border: InputBorder.none),
                  controller: _hoursTextController,
                  onChanged: (_) {
                    _setDoneButtonEnabled();
                  },
                ),
              )
            ],
          ),
        ),
        Container(
          width: 100,
          child: Row(
            children: <Widget>[
              Text(
                'Minutes: ',
                style: Theme.of(context).textTheme.subhead,
              ),
              Expanded(
                child: TextField(
                  decoration:
                      InputDecoration(hintText: '00', border: InputBorder.none),
                  keyboardType: TextInputType.number,
                  controller: _minTextController,
                  onChanged: (_) {
                    _setDoneButtonEnabled();
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Row _dateSelectionRow(
      String descText, String placeholder, Function callback) {
    return Row(
      children: <Widget>[
        Text(
          descText,
          style: Theme.of(context).textTheme.subhead,
          textAlign: TextAlign.left,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: Material(
            child: InkWell(
              child: Text(
                placeholder,
                style: Theme.of(context).textTheme.subhead,
              ),
              onTap: () {
                callback();
                _setDoneButtonEnabled();
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _dateSelectionRow(
                  'Start goal on:', _startDateString, _selectStartDate),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  _dateSelectionRow('End on:', _endDateString, _selectEndDate),
            ),

            // Segmented Control
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSegmentedControl(
                children: {
                  0: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Text('Time'),
                  ),
                  1: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Text('Task'),
                  ),
                },
                onValueChanged: (int val) {
                  setState(() {
                    _goalType = val;
                  });
                },
                groupValue: _goalType,
              ),
            ),
            // Duration or Task description
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(child: _goalDetailAreaBuilder())),
            Expanded(
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Cancel'),
                    onPressed: () {},
                  ),
                  RaisedButton(
                      child: Text('Done'),
                      onPressed: _doneEnabled
                          ? () {
                              _insertNewGoal();
                            }
                          : null),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
