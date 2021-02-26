import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skills/core/stringConstants.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/presentation/bloc/activeSessionScreen/activesession_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/actvityEditor/activityeditor_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/sessionBloc/session_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/sessionDataScreen/sessiondata_bloc.dart';
import 'package:skills/features/skills/presentation/pages/activeSessionScreen.dart';
import 'package:skills/features/skills/presentation/pages/skillsMasterScreen.dart';
import 'package:skills/features/skills/presentation/widgets/activitiesListSection.dart';
import 'package:skills/features/skills/presentation/widgets/eventCreator.dart';
import 'package:skills/features/skills/presentation/widgets/sessionForm.dart';
import 'package:skills/service_locator.dart';

import 'activityEditorScreen.dart';

class SessionDataScreen extends StatefulWidget {
  final SessiondataBloc bloc;

  const SessionDataScreen({Key key, this.bloc}) : super(key: key);
  @override
  _SessionDataScreenState createState() => _SessionDataScreenState(bloc);
}

class _SessionDataScreenState extends State<SessionDataScreen> {
  final SessiondataBloc bloc;

  _SessionDataScreenState(this.bloc);

  String get _sessionDateString {
    return DateFormat.yMMMd().format(bloc.session.date);
  }

  String get _startTimeString {
    return bloc.selectedStartTime.format(context);
  }

  String get _durationString {
    String minutes = bloc.session.duration.toString();
    return 'Duration: $minutes min.';
  }

  bool get _plusButtonEnabled {
    return bloc.availableTime > 0;
  }

  Widget _backArrow;

  @override
  Widget build(BuildContext context) {
    Widget body;
    return BlocProvider(
      builder: (context) => bloc,
      child: BlocListener<SessiondataBloc, SessionState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is SessionWasDeletedState) {
            Navigator.of(context).pop();
          }
        },
        child: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                leading: _backArrow,
              ),
              body: BlocBuilder<SessiondataBloc, SessionState>(
                builder: (context, state) {
                  if (state is SessiondataInitial ||
                      state is SessionDataCrudInProgressState ||
                      state is NewActivityCreatedState ||
                      state is ActivityRemovedFromSessionState) {
                    // TODO - showing spinner while events loading. Get events if getEvents UC hasn't been called?
                    body = Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Events loaded initially, reloaded after change or editing cancelled
                  else if (state is SessionDataInfoLoadedState ||
                      state is SessionDataActivitesLoadedState ||
                      state is SessionUpdatedAndRefreshedState ||
                      state is SessionViewingState) {
                    body = _infoViewBuilder(showEventCreator: false);
                  } else if (state is SessionEditingState) {
                    body = _editorViewBuilder();
                  } else if (state is SkillSelectedForSessionState) {
                    body = _infoViewBuilder(
                        showEventCreator: true, skill: state.skill);
                  }

                  return body;
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _editorViewBuilder() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SessionForm(
              session: bloc.session,
              sessionDate: bloc.sessionDate,
              cancelCallback: _onCancelEdit,
              onDoneEditingCallback: _onDoneEditing,
              onDeleteSessionCallback: _onDeleteSession,
            )
          ],
        ),
      ),
    );
  }

  Widget _infoViewBuilder({bool showEventCreator, Skill skill}) {
    return Container(
        child: Column(children: <Widget>[
      _infoSectionBuilder(),
      _actvityCreator(showEventCreator, skill),
      _activitiesSection(),
      Padding(
        padding: const EdgeInsets.all(8),
        child: _startButtonRow(),
      ),
    ]));
  }

  Widget _infoSectionBuilder() {
    return Container(
      child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: _dateRow(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: _startTimeRow(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: _availableTimeRow(),
        )
      ]),
    );
  }

  Widget _startButtonRow() {
    if (bloc.session.isComplete)
      return SizedBox();
    else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
              onPressed: bloc.canBeginSession ? _onStartSessionTapped : null,
              textColor: Colors.blueAccent,
              child: Text(
                BEGIN_SESSION,
                style: TextStyle(fontSize: 20),
              ))
        ],
      );
    }
  }

  Row _dateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text(
                _sessionDateString,
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: _statusIconBuilder(),
              ),
            ],
          ),
        ),
        Container(
            height: 30,
            width: 60,
            child: FlatButton(
              textColor: Colors.blueAccent,
              onPressed: _onEditTapped,
              child: Text('Edit'),
            )),
      ],
    );
  }

  Row _startTimeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          _startTimeString,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }

  Row _availableTimeRow() {
    var timeString = bloc.availableTime.toString();
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            _durationString,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            'Available: $timeString min.',
            style: Theme.of(context).textTheme.subtitle1,
          )
        ]);
  }

  Icon _statusIconBuilder() {
    Icon icon;

    if (bloc.session.isComplete) {
      icon = Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 20,
      );
    } else
      icon = Icon(
        Icons.calendar_today,
        color: Colors.grey,
        size: 20,
      );

    return icon;
  }

  Row _actvityCreator(bool showCreator, Skill skill) {
    Widget body;
    if (!showCreator) {
      body = SizedBox();
    } else {
      Map<String, dynamic> map = {'skill': skill, 'goal': skill.goal};
      body = EventCreator(
          eventMap: map,
          addEventCallback: _addActivity,
          cancelEventCreateCallback: _cancelActivityTapped);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[body],
    );
  }

  Widget _activitiesSection() {
    return ActivitiesListSection(
        activities: bloc.activitiesForSession,
        completedActivitiesCount: bloc.completedActivitiesCount,
        addTappedCallback: _showSkillsList,
        eventTappedCallback: _eventTapped,
        availableTime: bloc.availableTime);
  }

// ******* ACTIONS *******

  void _onEditTapped() {
    setState(() {
      bloc.add(BeginSessionEditingEvent());
      _backArrow = SizedBox();
    });
  }

  void _onCancelEdit() {
    setState(() {
      bloc.add(CancelSessionEditingEvent());
      _backArrow = null;
    });
  }

  void _onDoneEditing(Map<String, dynamic> changeMap) {
    setState(() {
      bloc.add(UpdateSessionEvent(changeMap));
      _backArrow = null;
    });
  }

  void _onDeleteSession() {
    bloc.add(DeleteSessionWithIdEvent(id: bloc.session.sessionId));
  }

  void _addActivity(int duration, Skill skill, String notesString) async {
    if (duration > bloc.availableTime) {
      await showDialog(
          context: (context),
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('The selected duration exceeds the time available.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    } else
      bloc.createActivity(duration, notesString, skill, bloc.sessionDate);
  }

  void _cancelActivityTapped() {
    bloc.add(CancelSkillForSessionEvent());
  }

  void _eventTapped(Activity activity) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 180,
            child: Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(EDIT),
                    onTap: () {
                      _editEventTapped(activity);
                    },
                  ),
                  ListTile(
                    title: Text(DELETE),
                    onTap: () {
                      _deleteEventTapped(activity);
                    },
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

  void _editEventTapped(Activity activity) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      ActivityEditorScreen activityEditorScreen = ActivityEditorScreen(
        bloc: locator<ActivityEditorBloc>(),
        availableTime: bloc.availableTime,
      );
      activityEditorScreen.bloc.activity = activity;

      return activityEditorScreen;
    }));

    Navigator.of(context).pop();
  }

  void _deleteEventTapped(Activity activity) async {
    await showDialog<bool>(
      context: (context),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete this Event?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                Activity event = activity;
                bloc.add(RemoveActivityFromSessionEvent(event.eventId));
              },
            )
          ],
        );
      },
    );
    Navigator.of(context).pop();
  }

  void _showSkillsList() async {
    var routeBuilder = PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SkillsMasterScreen(callback: _selectSkill),
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
        bloc.add(SkillSelectedForSessionEvent(skill: selectedSkill));
      });
    }
  }

  void _selectSkill(Skill skill) {
    Navigator.of(context).pop(skill);
  }

  void _onStartSessionTapped() async {
    bool refresh =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      ActiveSessionScreen activeSessionScreen = locator<ActiveSessionScreen>();
      activeSessionScreen.bloc.add(ActiveSessionLoadInfoEvent(
          session: bloc.session, activities: bloc.activitiesForSession));
      return activeSessionScreen;
    }));

    if (refresh) {
      bloc.add(GetSessionAndActivitiesEvent(sessionId: bloc.session.sessionId));
    }
  }
}
