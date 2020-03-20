import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/activeSessionScreen/activesession_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/bloc/session_bloc.dart';
import 'package:skills/features/skills/presentation/pages/skillsScreen.dart';
import 'package:skills/features/skills/presentation/widgets/activitiesListSection.dart';

class ActiveSessionScreen extends StatefulWidget {
  final ActiveSessionBloc bloc;

  const ActiveSessionScreen({Key key, this.bloc}) : super(key: key);
  @override
  _ActiveSessionScreenState createState() => _ActiveSessionScreenState(bloc);
}

class _ActiveSessionScreenState extends State<ActiveSessionScreen> {
  final ActiveSessionBloc bloc;

  _ActiveSessionScreenState(this.bloc);

  @override
  Widget build(BuildContext context) {
    Widget body;
    return BlocProvider(
      builder: (context) => bloc,
      child: BlocListener<ActiveSessionBloc, SessionState>(
        bloc: bloc,
        listener: (context, state) {},
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(),
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

              return body;
            }),
          );
        }),
      ),
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
        _activitiesSection(activities)
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
        Text('Choose an Activity to start with',
            style: Theme.of(context).textTheme.title)
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
    bloc.add(ActivitySelectedForTimerEvent(selectedActivity: activity));
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
