import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/new_session/bloc.dart';
import 'package:skills/features/skills/presentation/pages/skillsScreen.dart';
import 'package:skills/features/skills/presentation/widgets/eventCreator.dart';

class NewSessionScreen extends StatefulWidget {
  final DateTime date;
  final NewSessionBloc bloc;

  const NewSessionScreen({Key key, @required this.date, @required this.bloc})
      : super(key: key);
  @override
  _NewSessionScreenState createState() => _NewSessionScreenState(date, bloc);
}

class _NewSessionScreenState extends State<NewSessionScreen> {
  final DateTime date;
  final NewSessionBloc bloc;

  _NewSessionScreenState(this.date, this.bloc);

  bool _doneButtonEnabled = false;

  bool get _showEventCreator {
    return bloc.selectedSkill != null;
  }

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  Map<String, dynamic> currentEventMap = {};

  @override
  void initState() {
    super.initState();

    bloc.sessionDate ??= date;
  }

  String get _startTimeString {
    return bloc.selectedStartTime == null
        ? 'Select Time'
        : bloc.selectedStartTime.format(context);
  }

  String get _finishTimeString {
    return bloc.selectedFinishTime == null
        ? 'Select Time'
        : bloc.selectedFinishTime.format(context);
  }

  String get _durationString {
    String minutes = bloc.sessionDuration.toString();
    return 'Duration: $minutes min.';
  }

  bool get inEditingMode {
    return bloc.sessionForEdit != null;
  }

  void _setDoneBtnStatus() {
    setState(() {
      _doneButtonEnabled =
          bloc.selectedStartTime != null && bloc.selectedFinishTime != null;
    });
  }

  Container _contentBuilder() {
    return Container(
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                    child: Text(
                      DateFormat.yMMMd().format(date),
                      style: Theme.of(context).textTheme.title,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(8, 2, 8, 4),
                      child: _timeSelectionBox(
                          'Start: ', _startTimeString, _selectStartTime)),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(8, 2, 8, 4),
                      child: _timeSelectionBox(
                          'Finish: ', _finishTimeString, _selectFinishTime)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 8, 10),
                child: _timeRowBuilder(),
              ),
              _eventCreator(),
            ],
          ),
          _eventsHeaderBuilder(),
          _eventsListBuilder(),
          _buttonsBuilder(),
        ],
      ),
    );
  }

  ButtonBar _buttonsBuilder() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          child: Text('Cancel'),
          onPressed: () {
            _cancelTapped();
          },
        ),
        RaisedButton(
            child: Text('Done'),
            onPressed: _doneButtonEnabled
                ? () {
                    _doneTapped();
                  }
                : null),
      ],
    );
  }

  Column _eventsHeaderBuilder() {
    int eventCount = bloc.pendingEventMapsForListView.length;

    if (inEditingMode) {
      eventCount += bloc.eventMapsForSession.length;
    }
    String countString = eventCount.toString();

    return Column(
      children: <Widget>[
        Container(
            height: 40,
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Activities',
                      style: Theme.of(context).textTheme.subhead),
                  Text('$countString scheduled',
                      style: Theme.of(context).textTheme.subhead),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _showSkillsList();
                    },
                  )
                ],
              ),
            )),
      ],
    );
  }

  Row _timeRowBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(_durationString, style: Theme.of(context).textTheme.subhead),
        Text('Available: 30 min.', style: Theme.of(context).textTheme.subhead)
      ],
    );
  }

  ListView _eventsListBuilder() {
    List<Map> sourceList = inEditingMode
        ? bloc.eventMapsForSession
        : bloc.pendingEventMapsForListView;
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SessionEventCard(
          map: sourceList[index],
          callback: _eventTapped,
        );
      },
      itemCount: sourceList.length,
    );
  }

  Row _eventCreator() {
    Widget body;
    if (!_showEventCreator) {
      body = SizedBox();
    } else {
      Map<String, dynamic> map = {
        'skill': bloc.selectedSkill,
        'goal': bloc.currentGoal
      };
      body = EventCreator(
          eventMap: currentEventMap,
          addEventCallback: _addEvent,
          cancelEventCreateCallback: _cancelEventTapped);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[body],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => bloc,
      child: BlocListener<NewSessionBloc, NewSessionState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is NewSessionInsertedState) {
            // state returns events list if not empty, or pops
            if (state.events.isNotEmpty) {
              bloc.add(EventsForSessionCreationEvent(
                  events: state.events, session: state.newSession));
            } else {
              Navigator.of(context).pop();
            }
          } else if (state is EventsCreatedForSessionState) {
            Navigator.of(context).pop();
          }
        },
        child: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(title: Text('New Session')),
              body: BlocBuilder<NewSessionBloc, NewSessionState>(
                builder: (context, state) {
                  Widget body;
                  if (state is InitialNewSessionState) {
                    body = _contentBuilder();
                  // } else if (state is EditingSessionState) {
                  //   body = _contentBuilder();
                  } else if (state is NewSessionCrudInProgressState) {
                    body = Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is NewSessionInsertedState) {
                    body = Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SkillSelectedForEventState) {
                    bloc.selectedSkill = state.skill;
                    currentEventMap = {
                      'skill': bloc.selectedSkill,
                      'goal': bloc.currentGoal
                    };
                    body = _contentBuilder();
                  } else if (state is EventsCreatedForSessionState) {
                    body = Center(
                      child: CircularProgressIndicator(),
                    );
                    // Navigator.of(context).pop();
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

  // void noFlash() {
  //   Navigator.of(context).pop();
  // }

  Container _timeSelectionBox(
      String descText, String timeText, Function callback) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(descText, style: Theme.of(context).textTheme.subhead),
          InkWell(
            child: Text(timeText, style: Theme.of(context).textTheme.subhead),
            onTap: () {
              callback();
              _setDoneBtnStatus();
            },
          )
        ],
      ),
    );
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
                  setState(() {
                    if (inEditingMode) {
                      // delete existing event
                    } else {
                      bloc.pendingEventMapsForListView.remove(map);
                    }
                  });

                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _doneTapped() {
    bloc.createSession(date);
  }

  void _cancelTapped() {
    print('cancel');
  }

  void _addEvent(int eventDuration) {
    bloc.eventDuration = eventDuration;
    bloc.createEvent(date);
    setState(() {
      bloc.selectedSkill = null;
    });
  }

  void _cancelEventTapped() {
    setState(() {
      bloc.selectedSkill = null;
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
        bloc.add(SkillSelectedForSessionEvent(skill: selectedSkill));
      });
    }
  }

  void _selectSkill(Skill skill) {
    Navigator.of(context).pop(skill);
  }

  void _selectStartTime() async {
    TimeOfDay initial = TimeOfDay.now();
    if (bloc.selectedFinishTime != null) {
      initial = TimeOfDay(
          hour: bloc.selectedFinishTime.hour,
          minute: bloc.selectedFinishTime.minute - 5);
    }

    TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: initial,
    );

    if (selectedTime != null) {
      if (timeIsValid(selectedTime, bloc.selectedFinishTime, true)) {
        setState(() {
          bloc.selectedStartTime = selectedTime;
        });
      } else {
        _showInvalidTimeAlert();
        setState(() {
          bloc.selectedStartTime = null;
        });
      }
    }
    _setDoneBtnStatus();
  }

  void _selectFinishTime() async {
    TimeOfDay initial = TimeOfDay.now();
    if (bloc.selectedStartTime != null) {
      initial = TimeOfDay(
          hour: bloc.selectedStartTime.hour,
          minute: bloc.selectedStartTime.minute + 5);
    }
    TimeOfDay selectedTime =
        await showTimePicker(context: context, initialTime: initial);

    if (selectedTime != null) {
      if (timeIsValid(selectedTime, bloc.selectedStartTime, false)) {
        setState(() {
          bloc.selectedFinishTime = selectedTime;
        });
      } else {
        _showInvalidTimeAlert();
        setState(() {
          bloc.selectedFinishTime = null;
        });
      }
    }
    _setDoneBtnStatus();
  }

  void _showInvalidTimeAlert() async {
    await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Time'),
            content: Text(
                'Check your time. The session must last at least five minutes, and the start time must be prior to the finish time.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

bool timeIsValid(
    TimeOfDay selectedTime, TimeOfDay controlTime, bool isStartTime) {
  if (controlTime != null) {
    if (isStartTime) {
      return (selectedTime.hour < controlTime.hour ||
          (selectedTime.hour == controlTime.hour &&
              selectedTime.minute <= controlTime.minute - 5));
    } else {
      return (selectedTime.hour > controlTime.hour ||
          (selectedTime.hour == controlTime.hour &&
              selectedTime.minute >= controlTime.minute + 5));
    }
  } else
    return true;
}

typedef EventCardCallback(Map<String, dynamic> map);

class SessionEventCard extends StatelessWidget {
  final Map<String, dynamic> map;
  final EventCardCallback callback;
  // final SkillEvent event;

  const SessionEventCard({Key key, @required this.map, @required this.callback})
      : super(key: key);

  Widget goalSectionBuilder(Skill skill, BuildContext context) {
    Widget body = SizedBox();
    var goal = map['goal'];
    if (goal is Goal) {
      String goalTimeString = goal.timeRemaining.toString();
      body = Card(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(skill.goalText,
                      style: Theme.of(context).textTheme.body1),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('$goalTimeString min remaining',
                      style: Theme.of(context).textTheme.body1)
                ],
              )
            ],
          ),
        ),
      );
    }

    return body;
  }

  @override
  Widget build(BuildContext context) {
    String durationString = map['event'].duration.toString();
    Skill skill = map['skill'];
    // Goal goal = map['goal'];

    return GestureDetector(
      onTap: () {
        callback(map);
      },
      child: Card(
        color: Colors.amber[300],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(skill.name,
                        style: Theme.of(context).textTheme.subhead),
                    Text('$durationString min.',
                        style: Theme.of(context).textTheme.subhead),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(skill.source, style: Theme.of(context).textTheme.body1)
                  ],
                ),
                goalSectionBuilder(skill, context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
