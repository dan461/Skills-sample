import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skills/features/skills/presentation/bloc/new_session/bloc.dart';

class NewSessionScreen extends StatefulWidget {
  final DateTime date;

  const NewSessionScreen({Key key, @required this.date}) : super(key: key);
  @override
  _NewSessionScreenState createState() => _NewSessionScreenState(date);
}

class _NewSessionScreenState extends State<NewSessionScreen> {
  final DateTime date;
  TimeOfDay _selectedStartTime;
  TimeOfDay _selectedFinishTime;

  _NewSessionScreenState(this.date);

  String get _startTimeString {
    return _selectedStartTime == null
        ? 'Select Time'
        : _selectedStartTime.format(context);
  }

  String get _finishTimeString {
    return _selectedFinishTime == null
        ? 'Select Time'
        : _selectedFinishTime.format(context);
  }

  int get _duration {
    int minutes;
    if (_selectedStartTime == null || _selectedFinishTime == null)
      minutes = 0;
    else {
      int hours = _selectedFinishTime.hour - _selectedStartTime.hour;
      minutes =
          _selectedFinishTime.minute - _selectedStartTime.minute + hours * 60;
    }
    return minutes;
  }

  Container _contentBuilder(){
    return Container(
      child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          DateFormat.yMMMd().format(date),
                          style: Theme.of(context).textTheme.title,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _timeSelectionBox(
                              'Start: ', _startTimeString, _selectStartTime)),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _timeSelectionBox('Finish: ',
                              _finishTimeString, _selectFinishTime)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Duration: 30 min.',
                            style: Theme.of(context).textTheme.subhead),
                        Text('Available: 30 min.',
                            style: Theme.of(context).textTheme.subhead)
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  Container(
                      color: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Activities',
                                style: Theme.of(context).textTheme.subhead),
                            Text('0 scheduled',
                                style: Theme.of(context).textTheme.subhead),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {},
                            )
                          ],
                        ),
                      )),
                  _sessionActivityCard()
                ],
              ),
            )
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (_) => NewSessionBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('New Session'),
        ),
        body: BlocBuilder<NewSessionBloc, NewSessionState>(
          builder: (context, state){
            Widget body;
            if (state is InitialNewSessionState){
              body = _contentBuilder();
            }

            return body;
          },
        )
      ),
    );
  }

  Card _sessionActivityCard() {
    return Card(
      color: Colors.amber[300],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Bouree in E minor',
                      style: Theme.of(context).textTheme.subhead),
                  Text('30 min', style: Theme.of(context).textTheme.subhead),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('J.S. Bach', style: Theme.of(context).textTheme.body1)
                ],
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Goal: 1 hr 30 min by 11/30',
                          style: Theme.of(context).textTheme.body1),
                      Text('30 min completed',
                          style: Theme.of(context).textTheme.body1)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _timeSelectionBox(
      String descText, String timeText, Function callback) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(descText, style: Theme.of(context).textTheme.subhead),
          InkWell(
            child: Text(timeText, style: Theme.of(context).textTheme.subhead),
            onTap: () {
              callback();
            },
          )
        ],
      ),
    );
  }

  void _selectStartTime() async {
    TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _selectedStartTime = selectedTime;
      });
    }
  }

  void _selectFinishTime() async {
    TimeOfDay selectedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (selectedTime != null) {
      setState(() {
        _selectedFinishTime = selectedTime;
      });
    }
  }
}
