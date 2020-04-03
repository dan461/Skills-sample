import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skills/core/stringConstants.dart';

typedef StopwatchFinishedCallback(int elapsedTime);
typedef StopwatchCancelCallback();

class StopwatchWidget extends StatefulWidget {
  final StopwatchFinishedCallback finishedCallback;
  final StopwatchCancelCallback cancelCallback;

  const StopwatchWidget(
      {Key key, @required this.finishedCallback, @required this.cancelCallback})
      : super(key: key);

  @override
  _StopwatchWidgetState createState() =>
      _StopwatchWidgetState(finishedCallback, cancelCallback);
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  final StopwatchFinishedCallback finishedCallback;
  final StopwatchCancelCallback cancelCallback;

  _StopwatchWidgetState(this.finishedCallback, this.cancelCallback);

  Timer _timer;
  String startPauseString = START;

  int _elapsedSeconds = 0;

  String get _elapsedTimeString {
    String string = "";
    int minutes = (_elapsedSeconds / 60).floor();
    int hours = (minutes / 60).floor();
    if (hours > 0) {
      string = hours.toString() + " $HOURS_ABBR ";
    }

    int seconds = _elapsedSeconds - (minutes * 60);
    String secondsString = seconds.toString();

    string = string +
        minutes.toString() +
        " $MINUTES_ABBR " +
        secondsString +
        " $SECONDS_ABBR";

    return string;
  }

  bool get _canReset {
    return !_isRunning && _elapsedSeconds > 0;
  }

  bool get _isRunning {
    return _timer != null && _timer.isActive;
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Center(
              child: Text(_elapsedTimeString, style: TextStyle(fontSize: 18))),
          _buttonsRow(),
          _cancelRow()
        ],
      ),
    );
  }

  Row _buttonsRow() {
    List<Widget> buttons = [
      RaisedButton(
          child: Text(startPauseString),
          onPressed: () {
            _onStartPauseTap();
          })
    ];

    if (_isRunning) {
      buttons.add(_finishButton());
    }

    if (_canReset) {
      buttons.add(
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: RaisedButton(
            child: Text(RESET),
            onPressed: _onResetTapped,
          ),
        ),
      );
      buttons.add(_finishButton());
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }

  Widget _finishButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: RaisedButton(child: Text(FINISH), onPressed: _onFinishTapped),
    );
  }

  Row _cancelRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(child: Text(CANCEL), onPressed: _onCancelTapped)
      ],
    );
  }

  void _onResetTapped() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(RESET_TIMER),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(CANCEL),
              ),
              FlatButton(
                onPressed: () {
                  _reset();
                  Navigator.of(context).pop();
                },
                child: Text(RESET),
              )
            ],
          );
        });
  }

  void _onCancelTapped() async {
    
    if (_isRunning || _elapsedSeconds > 0) {
      _pause();
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(CANCEL_STOPWATCH),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _start();
                  },
                  child: Text(NO),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _cancelSession();
                  },
                  child: Text(YES),
                )
              ],
            );
          });
    } else {
      cancelCallback();
    }
  }

  void _cancelSession() {
    _timer.cancel();
    cancelCallback();
  }

  void _onFinishTapped() async {
    _showFinishTimerAlert();
  }

  void _showFinishTimerAlert() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(FINISH_ACTIVITY),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _start();
                  Navigator.of(context).pop();
                },
                child: Text(CANCEL),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  finishedCallback((_elapsedSeconds / 60).round());
                },
                child: Text(FINISH),
              )
            ],
          );
        });
  }

  void _onStartPauseTap() {
    if (_isRunning)
      _pause();
    else
      _start();
  }

  void _pause() {
    if (_isRunning) {
      _timer.cancel();
      setState(() {
        startPauseString = RESUME;
      });
    }
  }

  void _start() {
    setState(() {
      startPauseString = PAUSE;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _tick(Timer _timer) {
    setState(() {
      ++_elapsedSeconds;
    });
  }

  void _reset() {
    setState(() {
      _elapsedSeconds = 0;
      startPauseString = START;
    });
  }
}
