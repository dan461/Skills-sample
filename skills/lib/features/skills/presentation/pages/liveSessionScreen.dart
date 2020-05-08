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
  const LiveSessionScreen({Key key}) : super(key: key);

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

  TextEditingController _notesController = TextEditingController();

  String get _startButtonScreenText {
    return bloc.activities.isEmpty ? SELECT_TO_START : SELECT_ANOTHER;
  }

  bool get _saveEnabled {
    return bloc.activities.isNotEmpty;
  }

  bool get _cancelEnabled {
    return !_stopwatchActive;
  }

  bool _stopwatchActive = false;

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
        disabledColor: Colors.grey,
        icon: Icon(
          Icons.cancel,
          color: _cancelEnabled ? Colors.white : Colors.grey,
          size: 35,
        ),
        onPressed: _cancelEnabled ? _onCancelSession : null);
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
      _skillInfoSection(),
      _notesSection(),
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

  Widget _skillInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(bloc.selectedSkill.name,
                  style: Theme.of(context).textTheme.headline)
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(bloc.selectedSkill.source,
                    style: Theme.of(context).textTheme.subhead)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _notesSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _notesController,
              maxLength: 400,
              showCursor: true,
              decoration: InputDecoration(labelText: 'Notes'),
              maxLines: null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _timeTrackRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: StopwatchWidget(
            finishedCallback: _onStopwatchFinished,
            cancelCallback: _onStopwatchCancelled,
            activeStateCallback: _onStopwatchActiveStateChange,
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
      padding: const EdgeInsets.only(top: 8.0),
      child: ActiveSessionActivityList(
          activities: bloc.activities,
          activityTappedCallback: _onActivityTapped),
    );
  }

  void _onStopwatchActiveStateChange(bool isActive) {
    setState(() {
      _stopwatchActive = isActive;
    });
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
      bloc.add(LiveSessionActivityFinishedEvent(
          elapsedTime: elapsedTime, notes: _notesController.text));
    });
  }

  void _onStopwatchCancelled() {
    bloc.add(LiveSessionActivityCancelledEvent());
    setState(() {
      _stopwatchActive = false;
    });
  }
}
