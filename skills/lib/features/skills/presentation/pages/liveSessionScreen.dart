import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skills/core/stringConstants.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/liveSessionScreen/liveSessionScreen_bloc.dart';
import 'package:skills/features/skills/presentation/pages/skillsScreen.dart';
import 'package:skills/features/skills/presentation/widgets/activeSessionActivitiesList.dart';
import 'package:skills/features/skills/presentation/widgets/stopwatchWidget.dart';

import '../../../../service_locator.dart';

class LiveSessionScreen extends StatefulWidget {
  @override
  _LiveSessionScreenState createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen> {
  LiveSessionScreenBloc bloc;

  @override
  void initState() {
    bloc = locator<LiveSessionScreenBloc>();
    super.initState();
  }

  String get _startButtonScreenText {
    return bloc.activities.isEmpty ? SELECT_TO_START : SELECT_ANOTHER;
  }

  bool get _saveEnabled {
    return bloc.activities.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => bloc,
      child: BlocListener<LiveSessionScreenBloc, LiveSessionScreenState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is LiveSessionFinishedState)
            Navigator.of(context).pop(true);
        },
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(LIVE_SESSION),
              leading: _cancelButton(),
              actions: <Widget>[
                _saveButton(),
              ],
            ),
            body: BlocBuilder<LiveSessionScreenBloc, LiveSessionScreenState>(
                builder: (context, state) {
              Widget body;
              if (state is LiveSessionScreenInitial ||
                  state is LiveSessionSelectOrFinishState ||
                  state is LiveSessionFinishedState) {
                body = _selectionView();
              }
              // ready to start stopwatch
              else if (state is LiveSessionReadyState) {
                body = _stopwatchView();
              } else if (state is LiveSessionProcessingState) {
                body = Center(
                  child: CircularProgressIndicator(),
                );
              }

              return body;
            }),
          );
        }),
      ),
    );
  }

  IconButton _cancelButton() {
    return IconButton(
        icon: Icon(
          Icons.cancel,
          color: Colors.white,
          size: 35,
        ),
        onPressed: _onCancelSession);
  }

  FlatButton _saveButton() {
    return FlatButton(
      onPressed: _saveEnabled ? _onFinishSession : null,
      child: Text(
        SAVE,
        style: TextStyle(fontSize: 18),
      ),
      textColor: Colors.white,
    );
  }

  Column _selectionView() {
    List<Widget> content = [
      _dateTimeRow(),
      _durationRow(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: _selectionSection(),
      ),
      // _bottomButtonsRow()
    ];

    if (bloc.activities.length > 0) {
      content.add(_activitiesSection());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: content,
    );
  }

  Column _stopwatchView() {
    List<Widget> content = [
      _dateTimeRow(),
      _durationRow(),
      _skillInfoRow(),
      _timeTrackRow(),
      // _bottomButtonsRow()
    ];

    if (bloc.activities.length > 0) {
      content.add(_activitiesSection());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: content,
    );
  }

  Widget _skillInfoRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(bloc.selectedSkill.name,
              style: Theme.of(context).textTheme.headline)
        ],
      ),
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

  Widget _durationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          bloc.sessionDuration.toString() + ' ' + MINUTES_ABBR + ' completed',
          style: Theme.of(context).textTheme.subhead,
        )
      ],
    );
  }

  Widget _dateTimeRow() {
    return Container(
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(DateFormat.yMMMd().format(bloc.date),
                style: Theme.of(context).textTheme.title),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(bloc.startTime.format(context),
                style: Theme.of(context).textTheme.title),
          )
        ],
      ),
    );
  }

  Widget _selectionSection() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _startButtonScreenText,
              style: Theme.of(context).textTheme.subhead,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text(SELECT),
              onPressed: _showSkillsList,
              textColor: Colors.blueAccent,
            ),
          ],
        ),
      ],
    );
  }

  Widget _activitiesSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ActiveSessionActivityList(
          activities: bloc.activities,
          activityTappedCallback: _onActivityTapped),
    );
  }

  Widget _bottomButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
          child: RaisedButton(child: Text(CANCEL), onPressed: _onCancelSession),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          child: RaisedButton(child: Text(DONE), onPressed: _onFinishSession),
        )
      ],
    );
  }

  void _onFinishSession() {
    bloc.add(LiveSessionFinishedEvent());
  }

  void _onCancelSession() {
    if (bloc.activities.isNotEmpty) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(CANCEL_LIVE_SESSION),
              content: Text(ACTIVITIES_LOST),
              actions: <Widget>[
                FlatButton(
                  child: Text(NO),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(YES),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _cancelSession();
                  },
                )
              ],
            );
          });
    } else
      _cancelSession();
  }

  void _cancelSession() {
    Navigator.of(context).pop(false);
  }

  void _onActivityTapped(Activity activity) {}

  void _showSkillsList() async {
    var routeBuilder = PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SkillsScreen(callback: _selectSkill),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var tween = Tween(begin: begin, end: end);
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        });
    var selectedSkill = await Navigator.of(context).push(routeBuilder);
    if (selectedSkill != null) {
      setState(() {
        bloc.add(LiveSessionSkillSelectedEvent(skill: selectedSkill));
      });
    }
  }

  void _selectSkill(Skill skill) {
    Navigator.of(context).pop(skill);
  }

  void _onStopwatchFinished(int elapsedTime) {
    setState(() {
      bloc.add(LiveSessionActivityFinishedEvent(elapsedTime: elapsedTime));
    });
  }

  void _onStopwatchCancelled() {
    bloc.add(LiveSessionActivityCancelledEvent());
  }
}
