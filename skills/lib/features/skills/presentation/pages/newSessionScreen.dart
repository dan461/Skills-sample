
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skills/features/skills/presentation/bloc/new_session/bloc.dart';
import 'package:skills/service_locator.dart';

class NewSessionScreen extends StatefulWidget {
  final DateTime date;

  const NewSessionScreen({Key key, @required this.date}) : super(key: key);
  @override
  _NewSessionScreenState createState() => _NewSessionScreenState(date);
}

class _NewSessionScreenState extends State<NewSessionScreen> {
  final DateTime date;
  
  bool _doneButtonEnabled = false;
  NewSessionBloc _bloc;

  _NewSessionScreenState(this.date);

  @override
  void initState() {
    super.initState();
    _bloc = locator<NewSessionBloc>();
    _bloc.sessionDate = date;
  }

  String get _startTimeString {
    return _bloc.selectedStartTime == null
        ? 'Select Time'
        : _bloc.selectedStartTime.format(context);
  }

  String get _finishTimeString {
    return _bloc.selectedFinishTime == null
        ? 'Select Time'
        : _bloc.selectedFinishTime.format(context);
  }

  String get _durationString {
    String minutes = _bloc.duration.toString();
    return 'Duration: $minutes min.';
  }

  void _setDoneBtnStatus() {
    setState(() {
      _doneButtonEnabled =
          _bloc.selectedStartTime != null && _bloc.selectedFinishTime != null;
    });
  }

  void _doneTapped() {
    _bloc.createSession(date);
  }

  void _cancelTapped() {
    print('cancel');
  }

  Container _contentBuilder() {
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
                        child: _timeSelectionBox(
                            'Finish: ', _finishTimeString, _selectFinishTime)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_durationString,
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
                _sessionActivityCard(),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('Cancel'),
                onPressed: () {
                  _cancelTapped();
                },
              ),
              RaisedButton(
                  child: Text('Done'),
                  onPressed: _doneButtonEnabled
                      ? () {
                          _doneTapped();
                        }
                      : null),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body = _contentBuilder();
    return BlocListener<NewSessionBloc, NewSessionState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is InitialNewSessionState) {
          body = _contentBuilder();
        } else if (state is NewSessionInsertingState) {
          body = Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is NewSessionInsertedState) {
          body = Center(
            child: CircularProgressIndicator(),
          );
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('New Session')),
        body: body,
      ),
    );
  }

  void noFlash() {
    Navigator.of(context).pop();
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
              _setDoneBtnStatus();
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
        _bloc.selectedStartTime = selectedTime;
      });
    }
    _setDoneBtnStatus();
  }

  void _selectFinishTime() async {
    TimeOfDay selectedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (selectedTime != null) {
      setState(() {
        _bloc.selectedFinishTime = selectedTime;
      });
    }
    _setDoneBtnStatus();
  }
}
