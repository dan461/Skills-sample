import 'package:flutter/material.dart';
import 'package:skills/features/skills/presentation/widgets/stopwatch.dart';

class LiveSessionScreen extends StatefulWidget {
  @override
  _LiveSessionScreenState createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Session')),
      body: _stopwatchView(),
    );
  }

  Column _stopwatchView() {
    List<Widget> content = [_dateTimeRow(), _timeTrackRow()];

    // if (bloc.activities.lenght > 0){
    //   // add activities section
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: content,
    );
  }

  Widget _timeTrackRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StopwatchWidget(
            finishedCallback: _onStopwatchFinished,
            cancelCallback: _onStopwatchCancelled,
          ),
        )
      ],
    );
  }

  Column _selectionView() {
    List<Widget> content = [_dateTimeRow(), _selectionRow()];

    // if (bloc.activities.lenght > 0){
    //   // add activities section
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: content,
    );
  }

  Widget _dateTimeRow() {
    return Container(
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Mar. 28, 2020', style: Theme.of(context).textTheme.title),
          Text('7:10 pm', style: Theme.of(context).textTheme.title)
        ],
      ),
    );
  }

  Widget _selectionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          child: Text('Select a skill to get started.'),
          onPressed: _showSkillsList,
          textColor: Colors.blueAccent,
        ),
      ],
    );
  }

  void _showSkillsList() {}

  void _onStopwatchFinished(int elapsedTime) {}

  void _onStopwatchCancelled() {}
}
