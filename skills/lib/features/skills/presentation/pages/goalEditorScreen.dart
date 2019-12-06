import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skills/features/skills/presentation/bloc/goalEditorScreen/bloc.dart';
import 'package:skills/service_locator.dart';

class GoalCreationScreen extends StatefulWidget {
  final int skillId;
  final String skillName;

  const GoalCreationScreen(
      {Key key, @required this.skillId, @required this.skillName})
      : super(key: key);
  @override
  _GoalCreationScreenState createState() => _GoalCreationScreenState();
}

class _GoalCreationScreenState extends State<GoalCreationScreen> {
  GoaleditorBloc _bloc;
  int _goalType;

  bool _doneEnabled;

  @override
  void initState() {
    super.initState();
    _bloc = locator<GoaleditorBloc>();
    _goalType = 0;
    _doneEnabled = false;
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
    _bloc.insertNewGoal(
        startDate: _startDate.millisecondsSinceEpoch,
        endDate: _endDate.millisecondsSinceEpoch,
        timeBased: _isTimeBased,
        goalMinutes: _goalMinutes,
        skillId: widget.skillId,
        desc: _isTimeBased ? "none" : _goalDescTextController.text);
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
                    'Bouree in E Minor',
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (_) => _bloc,
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<GoaleditorBloc, GoalEditorState>(
          builder: (context, state) {
            Widget body;

            if (state is EmptyGoalEditorState) {
              body = _goalEditArea();
            } else if (state is NewGoalInsertedState) {
              // Need to update skill with currentGoalId and goalText
              _bloc.add(AddGoalToSkillEvent(
                  skillId: widget.skillId,
                  goalId: state.newGoalId,
                  goalText: _bloc.goalTranslation));
              body = Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GoalAddedToSkillState) {
              body = Center(
                child: CircularProgressIndicator(),
              );
              Navigator.of(context).pop();
            } else if (state is GoalCrudInProgressState) {
              body = Center(
                child: CircularProgressIndicator(),
              );
            }
            return body;
          },
        ),
      ),
    );
  }
}
