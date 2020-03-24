import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:skills/core/stringConstants.dart';

typedef CountdownTimerFinishedCallback(int timerDuration);

class Countdown extends StatefulWidget {
  final int minutesToCount;
  final CountdownTimerFinishedCallback finishedCallback;

  const Countdown(
      {Key key, @required this.minutesToCount, @required this.finishedCallback})
      : super(key: key);
  @override
  _CountdownState createState() =>
      _CountdownState(minutesToCount, finishedCallback);
}

class _CountdownState extends State<Countdown> {
  final int minutesToCount;
  final CountdownTimerFinishedCallback finishedCallback;
  // int minutesToCount = 0;
  Timer _timer;
  int _remainingSeconds;
  String startStop = START;

  _CountdownState(this.minutesToCount, this.finishedCallback);

  String get _timerString {
    _remainingSeconds ??= minutesToCount * 60;
    int minutes = (_remainingSeconds / 60).floor();
    int hours = (minutes / 60).floor();
    int seconds = _remainingSeconds - (minutes * 60);
    String string = "";
    if (hours > 0) {
      string = hours.toString() + " $HOURS_ABBR ";
    }
    string = minutes.toString() +
        " $MINUTES_ABBR " +
        seconds.toString() +
        " $SECONDS_ABBR";
    return string;
  }

  bool get _canReset {
    return !_timerRunning && _remainingSeconds < (minutesToCount * 60);
  }

  bool get _timerRunning {
    return _timer != null && _timer.isActive;
  }

  int get _elapsedTime {
    return (minutesToCount / _remainingSeconds).floor();
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Center(
          child: Text(_timerString, style: TextStyle(fontSize: 18)),
        ),
        _buttonsRow(),
        _cancelRow()
      ],
    ));
  }

  Row _buttonsRow() {
    List<Widget> buttons = [
      RaisedButton(
          child: Text(startStop),
          onPressed: () {
            _onStartPauseTap();
          })
    ];

    if (_timerRunning) {
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

  void _onCancelTapped() async {
    _pauseTimer();
    if (_timerRunning || _remainingSeconds < (minutesToCount * 60)) {
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(CANCEL_TIMER),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _startTimer();
                  },
                  child: Text(NO),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _cancelTimerSession();
                  },
                  child: Text(YES),
                )
              ],
            );
          });
    }
  }

  void _cancelTimerSession() {
    _timer.cancel();
    Navigator.of(context).pop(false);
  }

  void _onFinishTapped() async {
    _pauseTimer();
    if (_remainingSeconds < (minutesToCount * _remainingSeconds))
      _showIncompleteTimerAlert();
    else
      _showFinishTimerAlert();
  }

  void _showIncompleteTimerAlert() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(TIMER_IS_INCOMPLETE),
            content: Text('The timer has $_timerString remaining. Do you want you want to finish this activity?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _startTimer();
                  Navigator.of(context).pop();
                },
                child: Text(CANCEL),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _finishActivity();
                },
                child: Text(OK),
              )
            ],
          );
        });
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
                  _startTimer();
                  Navigator.of(context).pop();
                },
                child: Text(CANCEL),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _finishActivity();
                },
                child: Text(FINISH),
              )
            ],
          );
        });
  }

  void _finishActivity() {
    finishedCallback(_elapsedTime);
    // Navigator.of(context).pop();
    // setState(() {
    //   _timer.cancel();
    // });
  }

  void _onStartPauseTap() {
    if (_timerRunning) {
      _pauseTimer();
    } else
      _startTimer();
  }

  void _pauseTimer() {
    _timer.cancel();
    setState(() {
      startStop = RESUME;
    });
  }

  void _startTimer() {
    setState(() {
      startStop = PAUSE;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
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
                  _resetTimer();
                  Navigator.of(context).pop();
                },
                child: Text(RESET),
              )
            ],
          );
        });
  }

  void _resetTimer() {
    setState(() {
      _remainingSeconds = minutesToCount * 60;
      startStop = START;
    });
  }

  void _tick(Timer _timer) {
    setState(() {
      if (_remainingSeconds < 1) {
        _onTimerComplete();
      } else {
        --_remainingSeconds;
      }
    });
  }

  void _onTimerComplete() {}
}
