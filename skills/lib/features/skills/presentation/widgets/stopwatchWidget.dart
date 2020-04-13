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
    String minuteString = _nearestFive() == 0 ? '5' : _nearestFive().toString();
    String prefix = _elapsedSeconds < 150 ? '<' : '~';
    return '$prefix $minuteString min.';
  }

  int _nearestFive() {
    int minutes = (_elapsedSeconds / 60).round();
    minutes = (minutes / 5).round() * 5;
    return minutes;
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
    return ClipOval(
      child: Container(
        color: Colors.grey[200],
        height: 250,
        width: 250,
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child:
                        Text(_approxTimeString, style: TextStyle(fontSize: 24)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text('($_elapsedTimeString)',
                    style: TextStyle(fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buttonsRow(),
              ),
              _cancelRow()
            ],
          ),
        ),
      ),
    );
  }

  // Row _timeIndicatorRow() {
  //   return Row(
  //     children: <Widget>[
  //       Padding(
  //         padding: const EdgeInsets.only(right: 10),
  //         child: Text(_approxTimeString, style: TextStyle(fontSize: 24)),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.only(left: 10),
  //         child: Text('($_elapsedTimeString)', style: TextStyle(fontSize: 16)),
  //       ),
  //     ],
  //   );
  // }

  Row _buttonsRow() {
    List<Widget> buttons = [
      _startPauseButton(),
      _resetButton(),
      _finishButton()
    ];

    // if (_isRunning) {
    //   buttons.add(_finishButton());
    // }

    // if (_canReset) {
    //   buttons.add(IconButton(
    //       icon: Icon(Icons.replay, size: 60), onPressed: _onResetTapped));
    //   buttons.add(_finishButton());
    // }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }

  Widget _startPauseButton() {
    return IconButton(
        iconSize: 60,
        icon: startPauseIcon,
        onPressed: () {
          _onStartPauseTap();
        });
  }

  Widget _resetButton() {
    return IconButton(
        iconSize: 60,
        icon: Icon(Icons.replay),
        onPressed: _canReset ? _onResetTapped : null);
  }

  Widget _finishButton() {
    return IconButton(
      iconSize: 60,
      icon: Icon(Icons.stop),
      onPressed: _isRunning || _canReset ? _onFinishTapped : null,
    );
  }

  Row _cancelRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
            iconSize: 60,
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
        startPauseIcon = Icon(
          Icons.play_arrow,
        );
      });
    }
  }

  void _start() {
    setState(() {
      startPauseIcon = Icon(
        Icons.pause,
      );
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
      startPauseIcon = Icon(
        Icons.play_arrow,
      );
    });
  }
}
