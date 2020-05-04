import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skills/core/stringConstants.dart';
import 'package:skills/features/skills/presentation/helpers/stopwatchTimer.dart';

typedef StopwatchFinishedCallback(int elapsedTime);
typedef StopwatchCancelCallback();
typedef StopwatchActiveStateCallback(bool isActive);

class StopwatchWidget extends StatefulWidget {
  final StopwatchFinishedCallback finishedCallback;
  final StopwatchCancelCallback cancelCallback;
  final StopwatchActiveStateCallback activeStateCallback;

  const StopwatchWidget(
      {Key key,
      @required this.finishedCallback,
      @required this.cancelCallback,
      @required this.activeStateCallback})
      : super(key: key);

  @override
  StopwatchWidgetState createState() => StopwatchWidgetState(
      finishedCallback, cancelCallback, activeStateCallback);
}

class StopwatchWidgetState extends State<StopwatchWidget> {
  final StopwatchFinishedCallback finishedCallback;
  final StopwatchCancelCallback cancelCallback;
  final StopwatchActiveStateCallback activeStateCallback;

  StopwatchWidgetState(
      this.finishedCallback, this.cancelCallback, this.activeStateCallback);

  Timer _timer;
  String _startPauseString = START;
  String _stopResetString = STOP;
  Icon startPauseIcon = Icon(
    Icons.play_arrow,
  );

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

  String get _approxTimeString {
    String timeString = '0 min.';
    if (_elapsedSeconds > 0) {
      String minuteString =
          _nearestFive() == 0 ? '5' : _nearestFive().toString();
      String prefix = _elapsedSeconds < 150 ? '<' : '~';
      timeString = '$prefix $minuteString min.';
    }

    return timeString;
  }

  int _nearestFive() {
    int minutes = (_elapsedSeconds / 60).round();
    minutes = (minutes / 5).round() * 5;
    return minutes;
  }

  bool get _canReset {
    return !isRunning && _elapsedSeconds > 0;
  }

  bool get isRunning {
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
      color: Colors.grey[500],
      height: 230,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(_approxTimeString,
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text('($_elapsedTimeString)',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buttonsRow(),
            ),
            _cancelRow()
          ],
        ),
      ),
    );
  }

  Row _buttonsRow() {
    List<Widget> buttons = [_startPauseButton(), _resetButton(), _stopButton()];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }

  Widget _startPauseButton() {
    return RaisedButton(
      child: Text(_startPauseString),
      textColor: Colors.white,
      onPressed: _onStartPauseTap,
      color: Colors.grey[600],
    );
  }

  Widget _resetButton() {
    return IconButton(
        iconSize: 50,
        icon: Icon(
          Icons.replay,
          color: Colors.white,
        ),
        onPressed: _canReset ? _onResetTapped : null);
  }

  Widget _stopButton() {
    bool enableFinish = (isRunning || _canReset) && _elapsedSeconds > 150;
    return RaisedButton(
      textColor: Colors.white,
      disabledColor: Colors.grey[800],
      color: Colors.grey[600],
      child: Text(_stopResetString),
      onPressed: enableFinish ? _onStopTapped : null,
    );
  }

  Row _cancelRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
            iconSize: 50,
            icon: Icon(
              Icons.cancel,
              color: Colors.red,
            ),
            onPressed: _onCancelTapped)
      ],
    );
  }

  // ACTIONS

  void _onResetTapped() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(RESET_TIMER),
            actions: <Widget>[
              FlatButton(
                child: Text(CANCEL),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(RESET),
                onPressed: () {
                  _reset();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _onCancelTapped() async {
    if (isRunning || _elapsedSeconds > 0) {
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

  void _onStopTapped() async {
    _pause();
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
                  finishedCallback(_nearestFive());
                  activeStateCallback(false);
                },
                child: Text(FINISH),
              )
            ],
          );
        });
  }

  void _onStartPauseTap() {
    if (isRunning) {
      _pause();
    } else
      _start();
  }

  void _pause() {
    if (isRunning) {
      _timer.cancel();
      setState(() {
        _startPauseString = RESUME;
      });
    }
  }

  void _start() {
    setState(() {
      _startPauseString = PAUSE;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
    activeStateCallback(true);
  }

  void _tick(Timer _timer) {
    setState(() {
      ++_elapsedSeconds;
    });
  }

  void _reset() {
    setState(() {
      _elapsedSeconds = 0;
      activeStateCallback(false);
      startPauseIcon = Icon(
        Icons.play_arrow,
      );
    });
  }
}
