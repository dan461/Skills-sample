import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/presentation/bloc/new_session/bloc.dart';
import 'package:skills/features/skills/presentation/pages/skillsScreen.dart';
import 'package:skills/service_locator.dart';

class NewSessionScreen extends StatefulWidget {
  final DateTime date;

  const NewSessionScreen({Key key, @required this.date}) : super(key: key);
  @override
  _NewSessionScreenState createState() => _NewSessionScreenState(date);
}

class _NewSessionScreenState extends State<NewSessionScreen> {
  final DateTime date;

  bool _doneButtonEnabled = false;
  bool _eventCreateButtonEnabled = false;
  NewSessionBloc _bloc;
  Skill _selectedSkill;
  _NewSessionScreenState(this.date);

  TextEditingController _eventDurationTextControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = locator<NewSessionBloc>();
    _bloc.sessionDate = date;
  }

  String get _startTimeString {
    return _bloc.selectedStartTime == null
        ? 'Select Time'
        : _bloc.selectedStartTime.format(context);
  }

  String get _finishTimeString {
    return _bloc.selectedFinishTime == null
        ? 'Select Time'
        : _bloc.selectedFinishTime.format(context);
  }

  String get _durationString {
    String minutes = _bloc.sessionDuration.toString();
    return 'Duration: $minutes min.';
  }

  int get _eventDuration {
    int minutes = _eventDurationTextControl.text.isNotEmpty
        ? int.parse(_eventDurationTextControl.text)
        : 0;
    return minutes;
  }

  void _setDoneBtnStatus() {
    setState(() {
      _doneButtonEnabled =
          _bloc.selectedStartTime != null && _bloc.selectedFinishTime != null;
    });
  }

  void _setEventCreateButtonEnabled() {
    setState(() {
      _eventCreateButtonEnabled = _eventDuration > 0;
    });
  }

  Container _contentBuilder(Skill skill) {
    String countString = _bloc.eventMaps.length.toString();
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_durationString,
                        style: Theme.of(context).textTheme.subhead),
                    Text('Available: 30 min.',
                        style: Theme.of(context).textTheme.subhead)
                  ],
                ),
              ),
              _eventCreator(skill),
            ],
          ),
          Column(
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
          ),
          _eventsListBuilder(),
          ButtonBar(
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
          ),
        ],
      ),
    );
  }

  ListView _eventsListBuilder() {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SessionEventCard(
          map: _bloc.eventMaps[index],
        );
      },
      itemCount: _bloc.pendingEvents.length,
    );
  }

  Row _eventCreator(Skill skill) {
    Widget body;
    if (skill == null) {
      body = SizedBox();
    } else {
      body = Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Container(
          width: MediaQuery.of(context).size.width - 10,
          color: Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(skill.name, style: Theme.of(context).textTheme.subhead),
                  Container(
                    color: Colors.amber,
                    height: 30,
                    width: 100,
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Minutes: ',
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: '00', border: InputBorder.none),
                            keyboardType: TextInputType.number,
                            controller: _eventDurationTextControl,
                            onChanged: (_) {
                              _setEventCreateButtonEnabled();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ButtonBar(
                    buttonHeight: 30,
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          _cancelEventTapped();
                        },
                      ),
                      RaisedButton(
                          child: Text('Add'),
                          onPressed: _eventCreateButtonEnabled
                              ? () {
                                  _addEvent();
                                }
                              : null),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[body],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body = _contentBuilder(_selectedSkill);
    return BlocListener<NewSessionBloc, NewSessionState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is InitialNewSessionState) {
          body = _contentBuilder(null);
        } else if (state is NewSessionCrudInProgressState) {
          body = Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is NewSessionInsertedState) {
          body = Center(
            child: CircularProgressIndicator(),
          );
          // state returns events list if not empty, or pops
          if (state.events.isNotEmpty) {
            _bloc.add(EventsForSessionCreationEvent(
                events: state.events, session: state.newSession));
          } else {
            Navigator.of(context).pop();
          }
        } else if (state is SkillSelectedForEventState) {
          _selectedSkill = state.skill;
          body = _contentBuilder(_selectedSkill);
        } else if (state is EventsCreatedForSessionState) {
          body = Center(
            child: CircularProgressIndicator(),
          );
          Navigator.of(context).pop();
        }
        // TODO - probably don't need this, not creating events individually
        // else if (state is SkillEventCreatedState) {
        //   _selectedSkill = null;
        //   body = _contentBuilder(_selectedSkill);
        // }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('New Session')),
        body: body,
      ),
    );
  }

  void noFlash() {
    Navigator.of(context).pop();
  }

  Card _sessionActivityCard() {
    return Card(
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
                  Text('Bouree in E minor',
                      style: Theme.of(context).textTheme.subhead),
                  Text('30 min', style: Theme.of(context).textTheme.subhead),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('J.S. Bach', style: Theme.of(context).textTheme.body1)
                ],
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Goal: 1 hr 30 min by 11/30',
                          style: Theme.of(context).textTheme.body1),
                      Text('30 min completed',
                          style: Theme.of(context).textTheme.body1)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

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

  void _doneTapped() {
    _bloc.createSession(date);
  }

  void _cancelTapped() {
    print('cancel');
  }

  void _addEvent() {
    _bloc.eventDuration = _eventDuration;
    _bloc.createEvent(date);
    setState(() {
      _selectedSkill = null;
      _eventDurationTextControl.text = null;
    });
  }

  void _cancelEventTapped() {
    setState(() {
      _selectedSkill == null;
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
    var selectedSkillId = await Navigator.of(context).push(routeBuilder);
    if (selectedSkillId != null) {
      setState(() {
        // _selectedSkill = selectedSkill;
        _bloc.add(SkillSelectedForSessionEvent(skillId: selectedSkillId));
      });
    }
  }

  void _selectSkill(Skill skill) {
    Navigator.of(context).pop(skill.id);
  }

  void _selectStartTime() async {
    TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _bloc.selectedStartTime = selectedTime;
      });
    }
    _setDoneBtnStatus();
  }

  void _selectFinishTime() async {
    TimeOfDay selectedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (selectedTime != null) {
      setState(() {
        _bloc.selectedFinishTime = selectedTime;
      });
    }
    _setDoneBtnStatus();
  }
}

class SessionEventCard extends StatelessWidget {
  final Map<String, dynamic> map;
  // final SkillEvent event;

  const SessionEventCard({Key key, @required this.map}) : super(key: key);

  Widget goalSectionBuilder(Goal goal, Skill skill, BuildContext context) {
    Widget body = SizedBox();
    if (goal != null) {
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
    Goal goal = map['goal'];

    return Card(
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
                  Text(skill.name, style: Theme.of(context).textTheme.subhead),
                  Text('$durationString min.',
                      style: Theme.of(context).textTheme.subhead),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(skill.source, style: Theme.of(context).textTheme.body1)
                ],
              ),
              goalSectionBuilder(goal, skill, context)
            ],
          ),
        ),
      ),
    );
  }
}
