import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skills/core/tickTock.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/presentation/bloc/goalEditorScreen/bloc.dart';

import '../../../../service_locator.dart';

class GoalEditorScreen extends StatefulWidget {
  final int skillId;
  final int goalId;
  final String skillName;

  const GoalEditorScreen(
      {Key key,
      @required this.skillId,
      @required this.skillName,
      @required this.goalId})
      : super(key: key);
  @override
  _GoalEditorScreenState createState() => _GoalEditorScreenState(
      skillId: skillId, skillName: skillName, editedGoalId: goalId);
}

class _GoalEditorScreenState extends State<GoalEditorScreen> {
  final int skillId;
  final int editedGoalId;
  final String skillName;
  GoaleditorBloc _goalEditorBloc;
  int _goalType;

  bool _doneEnabled;

  FocusNode _focusNode = new FocusNode();

  _GoalEditorScreenState(
      {@required this.editedGoalId,
      @required this.skillId,
      @required this.skillName});

  @override
  void initState() {
    super.initState();
    _goalEditorBloc = locator<GoaleditorBloc>();
    if (editedGoalId != 0) {
      _goalEditorBloc.add(GetGoalEvent(goalId: editedGoalId));
    }
    _focusNode.addListener(_focusNodeListener);
    _goalType = 0;
    _doneEnabled = false;
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

  void _focusNodeListener() {
    if (_focusNode.hasFocus) {
      print('focus');
    } else
      print('no focus');
  }

  void goalIsChanged(String key, dynamic value) {
    Map changeMap = Map.from(_goalEditorBloc.goalModel.toMap());
    changeMap.update(key, (_) {
      return value;
    });
    // bool isChanged = _goalEditorBloc.goalIsChanged(changeMap);
  }

  void _setDoneButtonEnabled() {
    bool timeOrTaskSet;
    if (_isTimeBased)
      timeOrTaskSet = _goalMinutes > 0;
    else
      timeOrTaskSet = _goalDescTextController.text.isNotEmpty;

    _doneEnabled = _startDate != null && _endDate != null && timeOrTaskSet;
  }

  void _updateGoal() async {
    // TODO - finish this
    Goal updatedGoal = Goal(
        goalId: _goalEditorBloc.theGoal.goalId,
        skillId: _goalEditorBloc.theGoal.skillId,
        fromDate: _startDate,
        toDate: _endDate,
        timeBased: _isTimeBased,
        goalTime: _goalMinutes,
        timeRemaining: _goalMinutes,
        isComplete: false,
        desc: _isTimeBased ? "none" : _goalDescTextController.text);

    _goalEditorBloc.add(UpdateGoalEvent(updatedGoal));
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
      goalIsChanged('fromDate', pickedDate.millisecondsSinceEpoch);
      setState(() {
        _startDate =
            DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
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
        _endDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
      });
    }
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
                  focusNode: _focusNode,
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

  Container _goalEditArea() {
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
                              _updateGoal();
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
    return BlocProvider(
      builder: (_) => _goalEditorBloc,
      child: Builder(builder: (BuildContext context) {
        return BlocListener(
          bloc: _goalEditorBloc,
          listener: (context, state) {
            if (state is GoalUpdatedState || state is GoalDeletedState) {
              Navigator.of(context).pop(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(),
            body: BlocBuilder<GoaleditorBloc, GoalEditorState>(
              builder: (context, state) {
                Widget body;

                if (state is EmptyGoalEditorState ||
                    state is GoalCrudInProgressState) {
                  body = Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GoalEditorGoalReturnedState) {
                  body = Center(
                    child: CircularProgressIndicator(),
                  );
                  _setScreenValues(state.goal);
                  // _goalEditorBloc.goal = state.goal;
                  _goalEditorBloc.add(EditGoalEvent());
                } else if (state is GoalEditorEditingState) {
                  body = _goalEditArea();
                } else if (state is GoalUpdatedState ||
                    state is GoalDeletedState) {
                  body = Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return body;
              },
            ),
          ),
        );
      }),
    );
  }

  void _setScreenValues(Goal goal) {
    _startDate = goal.fromDate;
    _endDate = goal.toDate;
    _goalType = goal.timeBased == true ? 0 : 1;
    _hoursTextController.text = (goal.goalTime / 60).floor().toString();
    _minTextController.text = (goal.goalTime % 60).toString();
  }
}
