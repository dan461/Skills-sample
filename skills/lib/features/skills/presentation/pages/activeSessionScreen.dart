import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/core/stringConstants.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/activeSessionScreen/activesession_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/sessionBloc/session_bloc.dart';
import 'package:skills/features/skills/presentation/pages/skillsScreen.dart';
import 'package:skills/features/skills/presentation/widgets/activitiesListSection.dart';
import 'package:skills/features/skills/presentation/widgets/countdown.dart';
import 'package:skills/features/skills/presentation/widgets/stopwatchWidget.dart';

class ActiveSessionScreen extends StatefulWidget {
  final ActiveSessionBloc bloc;

  const ActiveSessionScreen({Key key, this.bloc}) : super(key: key);
  @override
  _ActiveSessionScreenState createState() => _ActiveSessionScreenState(bloc);
}

class _ActiveSessionScreenState extends State<ActiveSessionScreen> {
  final ActiveSessionBloc bloc;

  _ActiveSessionScreenState(this.bloc);
  Widget timeTracker;
  int _timeTrackerType = 0;
  bool _timeTrackerShown = false;

  @override
  Widget build(BuildContext context) {
    Widget body;
    return BlocProvider(
      builder: (context) => bloc,
      child: BlocListener<ActiveSessionBloc, SessionState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is ActiveSessionCompletedState) {
            Navigator.of(context).pop(true);
          }
        },
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              leading: SizedBox(),
            ),
            body: BlocBuilder<ActiveSessionBloc, SessionState>(
                builder: (context, state) {
              if (state is ActiveSessionInitial) {
                body = Center(child: CircularProgressIndicator());
              }
              // Info loaded
              else if (state is ActiveSessionInfoLoadedState) {
                body = _chooseActivityViewBuilder(
                    state.duration, state.activities);
              }

              // Activity selected
              else if (state is ActivityReadyState) {
                body = _timeTrackingViewBuilder(state.activity);
              }

              // Activity finished
              else if (state is CurrentActivityFinishedState) {
                body = Center(child: CircularProgressIndicator());
                bloc.add(ActiveSessionRefreshActivitiesEvent());
              }

              // Activities refreshed
              else if (state is ActiveSessionActivitiesRefreshedState) {
                body = _chooseActivityViewBuilder(
                    state.duration, state.activities);
              }

              return body;
            }),
          );
        }),
      ),
    );
  }

  Widget _timeTrackingViewBuilder(Activity activity) {
    var timeString = activity.duration.toString();
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(activity.skillString,
                    style: Theme.of(context).textTheme.title),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$timeString min.',
                    style: Theme.of(context).textTheme.title),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              'Notes: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _timeTrackerRow(),
        )
      ],
    );
  }

  Column _chooseActivityViewBuilder(int duration, List<Activity> activities) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _durationRow(duration),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _chooseRow(),
        ),
        _activitiesSection(activities),
        _buttonsRow()
      ],
    );
  }

  Row _timeTrackerRow() {
    timeTracker = null;
    if (_timeTrackerType == 0) {
      timeTracker = Countdown(
        minutesToCount: bloc.selectedActivity.duration,
        finishedCallback: _currentActivityFinished,
        cancelCallback: _timeTrackerCancelled,
      );
    } else {
      timeTracker = StopwatchWidget(
        finishedCallback: _currentActivityFinished,
        cancelCallback: _timeTrackerCancelled,
      );
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Expanded(child: Container(width: 200, height: 150, child: timeTracker)),
    ]);
  }

  Row _buttonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: RaisedButton(child: Text(CANCEL), onPressed: _onCancelTapped),
        ),
        RaisedButton(child: Text(COMPLETE), onPressed: _onCompleteTapped)
      ],
    );
  }

  Row _durationRow(int duration) {
    String durationString = duration.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('$durationString min.', style: Theme.of(context).textTheme.title)
      ],
    );
  }

  Row _chooseRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(SELECT_ACTIVITY, style: Theme.of(context).textTheme.title)
      ],
    );
  }

  Widget _activitiesSection(List<Activity> activities) {
    return ActivitiesListSection(
        activities: activities,
        completedActivitiesCount: bloc.completedActivitiesCount,
        addTappedCallback: _showSkillsList,
        eventTappedCallback: _activityTapped,
        availableTime: bloc.availableTime);
  }

  // ACTIONS

  void _onCompleteTapped() {
    if (bloc.allActivitiesComplete) {
      _showCompleteSessionAlert();
    } else {
      _showCompleteSessionAndActivitiesAlert();
    }
  }

  void _onCancelTapped() {
    Navigator.of(context).pop(true);
  }

  void _timeTrackerCancelled() {
    setState(() {
      _timeTrackerShown = false;
      timeTracker = null;
    });
    bloc.add(ActivityTimerStoppedEvent());
  }

  void _timeTrackerTypeSelected() {
    timeTracker = null;
    if (_timeTrackerType == 0) {
      timeTracker = Countdown(
        minutesToCount: bloc.selectedActivity.duration,
        finishedCallback: _currentActivityFinished,
        cancelCallback: _timeTrackerCancelled,
      );
    } else {
      timeTracker = StopwatchWidget(
        finishedCallback: _currentActivityFinished,
        cancelCallback: _timeTrackerCancelled,
      );
    }
  }

  void _countdownSelected() {
    timeTracker = Countdown(
      minutesToCount: bloc.selectedActivity.duration,
      finishedCallback: _currentActivityFinished,
      cancelCallback: _timeTrackerCancelled,
    );
    setState(() {
      _timeTrackerShown = true;
    });
  }

  void _stopwatchSelected() {
    timeTracker = StopwatchWidget(
      finishedCallback: _currentActivityFinished,
      cancelCallback: _timeTrackerCancelled,
    );
    setState(() {
      _timeTrackerShown = true;
    });
  }

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
        bloc.add(SkillSelectedForActiveSessionEvent(skill: selectedSkill));
      });
    }
  }

  void _selectSkill(Skill skill) {
    Navigator.of(context).pop(skill);
  }

  void _activityTapped(Activity activity) {
    if (activity.isComplete) {
      _showAlreadyCompleteAlert();
    } else
      bloc.add(ActivitySelectedForTimerEvent(selectedActivity: activity));
  }

  void _showCompleteSessionAlert() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(COMPLETE_SESSION_QRY),
            actions: <Widget>[
              FlatButton(
                child: Text(CANCEL),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(COMPLETE_IT),
                onPressed: () {
                  bloc.add(CompleteActiveSessionEvent());
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _showCompleteSessionAndActivitiesAlert() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(INCOMPLETE_ACTIVITIES),
            content: Text(COMPLETE_SESSION_AND_ACTS_QRY),
            actions: <Widget>[
              FlatButton(
                child: Text(CANCEL),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(COMPLETE_IT),
                onPressed: () {
                  Navigator.of(context).pop();
                  bloc.add(CompleteActiveSessionEvent());
                },
              ),
            ],
          );
        });
  }

  void _showAlreadyCompleteAlert() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(ACTIVITY_IS_COMPLETED),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(OK),
              ),
            ],
          );
        });
  }

  void _currentActivityFinished(int elapsedTime) {
    bloc.add(CurrentActivityFinishedEvent(
        activity: bloc.selectedActivity, elapsedTime: elapsedTime));
  }
}

// class SessionScreen extends StatefulWidget {
//   final SessionBloc bloc;

//   const SessionScreen({Key key, this.bloc}) : super(key: key);
//   @override
//   _SessionScreenState createState() => _SessionScreenState(bloc);
// }

// class _SessionScreenState extends State<SessionScreen> {
//   final SessionBloc bloc;

//   _SessionScreenState(this.bloc);
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }

//   void _addActivity(int duration, Skill skill) async {
//     if (duration > bloc.availableTime) {
//       await showDialog(
//           context: (context),
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('The selected duration exceeds the time available.'),
//               actions: <Widget>[
//                 FlatButton(
//                   child: Text('Ok'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 )
//               ],
//             );
//           });
//     } else
//       bloc.createActivity(duration, skill, bloc.session.date);
//   }

//   void _showSkillsList() async {
//     var routeBuilder = PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) =>
//             SkillsScreen(callback: _selectSkill),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           var begin = Offset(0.0, 1.0);
//           var end = Offset.zero;
//           var tween = Tween(begin: begin, end: end);
//           var offsetAnimation = animation.drive(tween);
//           return SlideTransition(
//             position: offsetAnimation,
//             child: child,
//           );
//         });
//     var selectedSkill = await Navigator.of(context).push(routeBuilder);
//     if (selectedSkill != null) {
//       setState(() {
//         bloc.add(SkillSelectedForSessionEvent(skill: selectedSkill));
//       });
//     }
//   }
// }

// Row _timerSelectionRow() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: <Widget>[
//       CupertinoSegmentedControl(
//         children: {
//           0: Padding(
//             padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
//             child: Text('Timer'),
//           ),
//           1: Padding(
//             padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
//             child: Text('Stopwatch'),
//           ),
//         },
//         onValueChanged: (int val) {
//           setState(() {
//             _timerType = val;
//             _timerTypeSelected();
//           });
//         },
//         groupValue: _timerType,
//       )
//     ],
//   );
// }
// Widget _timerSelectionSection() {
//   Widget section;
//   if (_timeTrackerShown)
//     section = SizedBox();
//   else {
//     section = Column(
//       children: <Widget>[
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Select a timer or a stopwatch',
//               style: Theme.of(context).textTheme.headline,
//             ),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             RaisedButton(child: Text('Timer'), onPressed: _timerSelected),
//             RaisedButton(
//                 child: Text('Stopwatch'), onPressed: _stopwatchSelected),
//           ],
//         ),
//       ],
//     );
//   }

//   return section;
// }
