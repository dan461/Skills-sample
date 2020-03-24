import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skills/core/stringConstants.dart';

typedef CountdownTimerStopCallback();

class Countdown extends StatefulWidget {
  final int minutesToCount;
  // final CountdownTimerStopCallback startCallback;

  const Countdown({Key key, @required this.minutesToCount}) : super(key: key);
  @override
  _CountdownState createState() => _CountdownState(minutesToCount);
}

class _CountdownState extends State<Countdown> {
  final int minutesToCount;
  // final CountdownTimerStopCallback startCallback;
  // int minutesToCount = 0;
  Timer _timer;
  int _remainingSeconds;
  String startStop = START;

  _CountdownState(this.minutesToCount);

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
        _buttonsRow()
      ],
    ));
  }

  Row _buttonsRow() {
    List<Widget> buttons = [
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: RaisedButton(
            child: Text(startStop),
            onPressed: () {
              _onStartPauseTap();
            }),
      )
    ];

    if (_timerRunning) {
      buttons.add(RaisedButton(child: Text(STOP), onPressed: _stopTimer));
    }

    if (_canReset) {
      buttons.add(Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: RaisedButton(child: Text(RESET), onPressed: _resetTimer),
      ));
      buttons.add(RaisedButton(child: Text(STOP), onPressed: _stopTimer));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
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

  void _resetTimer() {
    setState(() {
      _remainingSeconds = minutesToCount * 60;
      startStop = START;
    });
  }

  void _tick(Timer _timer) {
    setState(() {
      if (_remainingSeconds < 1) {
        _stopTimer();
      } else {
        --_remainingSeconds;
      }
    });
  }

  void _stopTimer() {
    setState(() {
      _timer.cancel();
    });
  }
}
