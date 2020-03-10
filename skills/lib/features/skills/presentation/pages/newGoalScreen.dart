import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skills/core/tickTock.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/presentation/bloc/newGoalScreen/newgoal_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/newGoalScreen/newgoal_event.dart';
import 'package:skills/features/skills/presentation/bloc/newGoalScreen/newgoal_state.dart';

import '../../../../service_locator.dart';

class NewGoalScreen extends StatefulWidget {
  final int skillId;
  final String skillName;

  const NewGoalScreen(
      {Key key, @required this.skillId, @required this.skillName})
      : super(key: key);
  @override
  _NewGoalScreenState createState() => _NewGoalScreenState(skillId, skillName);
}

class _NewGoalScreenState extends State<NewGoalScreen> {
  final int skillId;
  final String skillName;
  int _goalType;
  bool _doneEnabled;
  String _goalTranslation;

  _NewGoalScreenState(this.skillId, this.skillName);

  @override
  void initState() {
    super.initState();

    _goalType = 0;
    _doneEnabled = false;
    _goalTranslation = '';
  }

  TextEditingController _hoursTextController = TextEditingController();
  TextEditingController _minTextController = TextEditingController();
  TextEditingController _goalDescTextController = TextEditingController();

  DateTime _startDate;
  DateTime _endDate;

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

// TODO - BUG: exception thrown if a decimal value used
  int get _goalMinutes {
    int hours = _hoursTextController.text.isNotEmpty
        ? int.parse(_hoursTextController.text)
        : 0;
    int minutes = _minTextController.text.isNotEmpty
        ? int.parse(_minTextController.text)
        : 0;

    int totalMinutes = (hours * 60) + minutes;
    return totalMinutes;
  }

  void _setDoneButtonEnabled() {
    bool timeOrTaskSet;
    if (_isTimeBased)
      timeOrTaskSet = _goalMinutes > 0;
    else
      timeOrTaskSet = _goalDescTextController.text.isNotEmpty;

    setState(() {
      _doneEnabled = _startDate != null && _endDate != null && timeOrTaskSet;
    });

    // _doneEnabled = _startDate != null && _endDate != null;
  }

  void _selectStartDate() async {
    DateTime lastDate = _endDate ?? TickTock.today().add(Duration(days: 365));

    DateTime initialDate =
        TickTock.today().isBefore(lastDate) ? TickTock.today() : lastDate;

    DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: TickTock.today().subtract(Duration(days: 365)),
        lastDate: lastDate);

    if (pickedDate != null) {
      setState(() {
        _startDate =
            DateTime.utc(pickedDate.year, pickedDate.month, pickedDate.day);
        print(_startDate);
      });
    }
  }

  void _selectEndDate() async {
    DateTime firstDate =
        _startDate ?? TickTock.today().subtract(Duration(days: 365));

    DateTime initialDate =
        TickTock.today().isAfter(firstDate) ? TickTock.today() : _startDate;

    DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: TickTock.today().add(Duration(days: 365)));

    if (pickedDate != null) {
      setState(() {
        _endDate =
            DateTime.utc(pickedDate.year, pickedDate.month, pickedDate.day);
      });
    }
  }

  void _insertNewGoal(BuildContext context) async {
    Goal newGoal = Goal(
        skillId: skillId,
        fromDate: _startDate,
        toDate: _endDate,
        timeBased: _isTimeBased,
        goalTime: _goalMinutes,
        timeRemaining: _goalMinutes,
        isComplete: false,
        desc: _isTimeBased ? "none" : _goalDescTextController.text);
    _goalTranslation =
        BlocProvider.of<NewgoalBloc>(context).translateGoal(newGoal);
    BlocProvider.of<NewgoalBloc>(context).add(InsertNewGoalEvent(newGoal));
  }

  Widget _goalDetailAreaBuilder() {
    Widget area;
    if (_isTimeBased)
      area = _goalTimeSelectionArea();
    else
      area = _goalDescriptionField();

    return area;
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

  Container _goalEditArea(BuildContext blocContext) {
    return Container(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.skillName,
                    style: Theme.of(context).textTheme.title,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
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
                              _insertNewGoal(blocContext);
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewgoalBloc>(
      builder: (_) => locator<NewgoalBloc>(),
      child: BlocListener<NewgoalBloc, NewgoalState>(
        listener: (context, state) {
          if (state is GoalAddedToSkillState) {
            Navigator.of(context).pop(true);
          }
        },
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(),
            body: BlocBuilder<NewgoalBloc, NewgoalState>(
              builder: (context, state) {
                Widget body;
                if (state is InitialNewgoalState) {
                  body = _goalEditArea(context);
                } else if (state is NewGoalInsertingState ||
                    state is AddingGoalToSkillState) {
                  body = Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is NewGoalInsertedState) {
                  // Need to update skill with currentGoalId and goalText
                  BlocProvider.of<NewgoalBloc>(context).add(AddGoalToSkillEvent(
                      skillId: widget.skillId, goalId: state.newGoal.goalId));
                  body = Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GoalAddedToSkillState) {
                  body = Center(child: CircularProgressIndicator());
                }

                return body;
              },
            ),
          );
        }),
      ),
    );
  }
}
