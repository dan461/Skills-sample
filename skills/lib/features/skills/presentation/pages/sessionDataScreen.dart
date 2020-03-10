import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/presentation/bloc/sessionDataScreen/sessiondata_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/sessionEditorScreen/session_editor_state.dart';
import 'package:skills/features/skills/presentation/pages/skillsScreen.dart';
import 'package:skills/features/skills/presentation/widgets/eventCreator.dart';
import 'package:skills/features/skills/presentation/widgets/sessionEventCell.dart';
import 'package:skills/features/skills/presentation/widgets/sessionForm.dart';

class SessionDataScreen extends StatefulWidget {
  final SessiondataBloc bloc;

  const SessionDataScreen({Key key, @required this.bloc}) : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    Widget body;
    return BlocProvider(
      builder: (context) => bloc,
      child: BlocListener<SessiondataBloc, SessiondataState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is SessionWasDeletedState) {
            Navigator.of(context).pop();
          }
        },
        child: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(),
              body: BlocBuilder<SessiondataBloc, SessiondataState>(
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
                  else if (state is SessionDataEventsLoadedState ||
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
      _eventsSectionBuilder()
    ]));
  }

  Widget _infoSectionBuilder() {
    return Container(
      child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
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

  Row _dateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text(
                _sessionDateString,
                style: Theme.of(context).textTheme.title,
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
          style: Theme.of(context).textTheme.subhead,
        ),
        Text(
          _durationString,
          style: Theme.of(context).textTheme.subhead,
        )
      ],
    );
  }

  Row _availableTimeRow() {
    var timeString = bloc.availableTime.toString();
    return Row(children: <Widget>[
      Text(
        'Available: $timeString min.',
        style: Theme.of(context).textTheme.subhead,
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

  

  Column _eventsSectionBuilder() {
    return Column(
      children: <Widget>[_eventsHeaderBuilder(), _eventsListBuilder()],
    );
  }

  Widget _eventsHeaderBuilder() {
    int count = bloc.activityMapsForListView.isEmpty
        ? 0
        : bloc.completedActivitiesCount;
    String suffix =
        bloc.activityMapsForListView.isEmpty ? 'scheduled' : 'completed';
    String countString = count.toString() + ' $suffix';

    return Container(
        height: 40,
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Activities', style: Theme.of(context).textTheme.subhead),
              Text('$countString', style: Theme.of(context).textTheme.subhead),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _plusButtonEnabled
                    ? () {
                        _showSkillsList();
                      }
                    : null,
              )
            ],
          ),
        ));
  }

  ListView _eventsListBuilder() {
    List sourceList = bloc.activityMapsForListView;
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SessionEventCell(
          map: sourceList[index],
          callback: _eventTapped,
        );
      },
      itemCount: sourceList.length,
    );
  }

// ******* ACTIONS *******

  void _onEditTapped() {
    setState(() {
      bloc.add(BeginSessionEditingEvent());
    });
  }

  void _onCancelEdit() {
    setState(() {
      bloc.add(CancelSessionEditingEvent());
    });
  }

  void _onDoneEditing(Map<String, dynamic> changeMap) {
    setState(() {
      bloc.add(UpdateSessionEvent(changeMap));
    });
  }

  void _onDeleteSession() {
    bloc.add(DeleteSessionWithIdEvent(id: bloc.session.sessionId));
  }

  void _addActivity(int duration, Skill skill) async {
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
      bloc.createActivity(duration, skill);
  }

  void _cancelActivityTapped() {
    bloc.add(CancelSkillForSessionEvent());
  }

  void _eventTapped(Map<String, dynamic> map) {
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
                    title: Text('Edit (no function)'),
                    onTap: () {
                      _editEventTapped(map);
                    },
                  ),
                  ListTile(
                    title: Text('Delete'),
                    onTap: () {
                      _deleteEventTapped(map);
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

  void _editEventTapped(Map<String, dynamic> map) {
    // setState(() {
    //   _bloc.selectedSkill = map['skill'];
    //   currentEventMap = map;
    // });
  }

  void _deleteEventTapped(Map<String, dynamic> map) async {
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
                SkillEvent event = map['event'];
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
        bloc.add(SkillSelectedForSessionEvent(skill: selectedSkill));
      });
    }
  }

  void _selectSkill(Skill skill) {
    Navigator.of(context).pop(skill);
  }
}
