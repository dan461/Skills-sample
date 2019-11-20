import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:skills/features/skills/presentation/pages/homeScreen.dart';

class GoalCreationScreen extends StatefulWidget {
  @override
  _GoalCreationScreenState createState() => _GoalCreationScreenState();
}

class _GoalCreationScreenState extends State<GoalCreationScreen> {
  int _goalType;

  @override
  void initState() {
    super.initState();
    _goalType = 0;
  }

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

  DateTime _startDate;
  DateTime _endDate;

  Future<Null> _selectStartDate(BuildContext context) async {
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

  Future<Null> _selectEndDate(BuildContext context) async {
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
    if (_goalType == 0)
      area = _goalTimeSelectionArea();
    else if (_goalType == 1) area = _goalDescriptionField();

    return area;
  }

  TextField _goalDescriptionField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Goal Description'),
      maxLength: 250,
      maxLines: 4,
      maxLengthEnforced: true,
      keyboardType: TextInputType.text,
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
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
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
                child: Row(
                  children: <Widget>[
                    Text(
                      'Start goal on:',
                      style: Theme.of(context).textTheme.subhead,
                      textAlign: TextAlign.left,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Material(
                        child: InkWell(
                          child: Text(
                            _startDateString,
                            style: Theme.of(context).textTheme.subhead,
                          ),
                          onTap: () {
                            _selectStartDate(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'End On:',
                      style: Theme.of(context).textTheme.subhead,
                      textAlign: TextAlign.left,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Material(
                        child: InkWell(
                          child: Text(
                            _endDateString,
                            style: Theme.of(context).textTheme.subhead,
                          ),
                          onTap: () {
                            _selectEndDate(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
                      onPressed: () {
                       
                      },
                    ),
                    RaisedButton(
                      child: Text('Done'),
                      onPressed: () {},
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
