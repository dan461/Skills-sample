import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skills/core/tickTock.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/new_session/bloc.dart';
import 'package:skills/features/skills/presentation/bloc/sessionEditorScreen/bloc.dart';
import 'package:skills/features/skills/presentation/pages/skillsScreen.dart';
import 'package:skills/features/skills/presentation/widgets/eventCreator.dart';
import 'package:skills/features/skills/presentation/widgets/sessionEventCell.dart';

class SessionEditorScreen extends StatefulWidget {
  final SessionEditorBloc bloc;
  final Session session;

  const SessionEditorScreen(
      {Key key, @required this.bloc, @required this.session})
      : super(key: key);
  @override
  _SessionEditorScreenState createState() => _SessionEditorScreenState(bloc);
}

class _SessionEditorScreenState extends State<SessionEditorScreen> {
  final SessionEditorBloc bloc;

  _SessionEditorScreenState(this.bloc);

  bool _doneButtonEnabled = true;
  bool get _plusButtonEnabled {
    return bloc.availableTime > 0;
  }

  Map<String, dynamic> currentEventMap = {};

  String get _sessionDateString {
    return DateFormat.yMMMd().format(bloc.sessionDate);
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

  bool _showEventCreator = false;

  // bool get _showEventCreator {
  //   return bloc.selectedSkill != null;
  // }

  @override
  Widget build(BuildContext context) {
    // assert(debugCheckHasMaterial(context));
    Widget body;
    return BlocProvider(
      builder: (context) => bloc,
      child: BlocListener<SessionEditorBloc, SessionEditorState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is SessionUpdatedState ||
              state is SessionDeletedState ||
              state is SessionEditorFinishedEditingState) {
            body = Center(
              child: CircularProgressIndicator(),
            );
            Navigator.of(context).pop();
          }
        },
        child: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(title: Text('New Session')),
              persistentFooterButtons: <Widget>[
                RaisedButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    // TODO - warn if unsaved changes
                    Navigator.of(context).pop();
                  },
                ),
                RaisedButton(
                  child: Text('Complete'),
                  onPressed: () {
                    _completeTapped();
                  },
                ),
                RaisedButton(
                    child: Text('Delete'),
                    onPressed: _doneButtonEnabled
                        ? () {
                            _deleteSessionTapped();
                          }
                        : null),
                RaisedButton(
                    child: Text('Done'),
                    onPressed: _doneButtonEnabled
                        ? () {
                            _doneTapped();
                          }
                        : null),
              ],
              body: BlocBuilder<SessionEditorBloc, SessionEditorState>(
                builder: (context, state) {
                  // Widget body;
                  // TODO - find better way to deal with the Bloc's dependency on a session
                  if (state is InitialSessionEditorState) {
                    body = Center(
                      child: CircularProgressIndicator(),
                    );
                    bloc.add(BeginSessionEditingEvent(session: widget.session));
                  }
                  // EDITING SESSION
                  else if (state is EditingSessionState) {
                    body = _contentBuilder();
                  }
                  // Spinner
                  else if (state is SessionEditorCrudInProgressState) {
                    body = Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // Skill Selected, show Event Creator
                  else if (state is SkillSelectedForSessionEditorState) {
                    _showEventCreator = true;
                    body = _contentBuilder();
                  }
                  // New Event created, hide Event Creator
                  else if (state is NewEventsCreatedState) {
                    _showEventCreator = false;
                    bloc.add(RefreshEventsListEvnt());
                    body = Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // Event Deleted
                  else if (state is EventDeletedFromSessionState) {
                    bloc.add(RefreshEventsListEvnt());
                    body = Center(
                      child: CircularProgressIndicator(),
                    );
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

  // ******* BUILDERS **********

  Container _contentBuilder() {
    return Container(
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              _dateRowBuilder(),
              _timeSelectRow(),
              _timeRowBuilder(),
              _eventCreator(),
            ],
          ),
          _eventsHeaderBuilder(),
          Expanded(child: _eventsListBuilder()),
          // _buttonsBuilder(),
        ],
      ),
    );
  }

  Row _dateRowBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
          child: Material(
            shape:
                Border(bottom: BorderSide(color: Colors.blue[100], width: 1.0)),
            child: InkWell(
              child: Text(
                _sessionDateString,
                style: Theme.of(context).textTheme.title,
              ),
              onTap: () {
                _pickNewDate();
              },
            ),
          ),
        )
      ],
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
          eventMap: map,
          addEventCallback: _addEvent,
          cancelEventCreateCallback: _cancelEventTapped);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[body],
    );
  }

  ButtonBar _buttonsBuilder() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          child: Text('Cancel'),
          onPressed: () {
            // _cancelTapped();
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
    int count =
        bloc.eventMapsForListView.isEmpty ? 0 : bloc.completedEventsCount;
    String suffix =
        bloc.eventMapsForListView.isEmpty ? 'scheduled' : 'completed';
    String countString = count.toString() + ' $suffix';

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
                  Text('$countString',
                      style: Theme.of(context).textTheme.subhead),
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
            )),
      ],
    );
  }

  ListView _eventsListBuilder() {
    List sourceList = bloc.eventMapsForListView;
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

  Widget _timeRowBuilder() {
    var timeString = bloc.availableTime.toString();
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(_durationString, style: Theme.of(context).textTheme.subhead),
          Text('Available: $timeString min.',
              style: Theme.of(context).textTheme.subhead)
        ],
      ),
    );
  }

  Row _timeSelectRow() {
    return Row(
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
              // _setDoneBtnStatus();
            },
          )
        ],
      ),
    );
  }

// ****** ACTIONS *********

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
        bloc.add(SkillSelectedForExistingSessionEvent(skill: selectedSkill));
      });
    }
  }

  void _selectSkill(Skill skill) {
    Navigator.of(context).pop(skill);
  }

  void _selectStartTime() async {
    TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: bloc.sessionForEdit.startTime,
    );

    if (selectedTime != null) {
      // TODO - Time validation

      setState(() {
        if (TickTock.timesAreEqual(selectedTime, bloc.selectedStartTime) ==
            false) {
          bloc.changeStartTime(selectedTime);
        }
      });
    }

    _setDoneBtnStatus();
  }

  void _selectFinishTime() async {
    TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: bloc.sessionForEdit.endTime,
    );

    if (selectedTime != null) {
      // TODO - Time validation
      setState(() {
        if (TickTock.timesAreEqual(selectedTime, bloc.selectedFinishTime) ==
            false) {
          bloc.changeFinishTime(selectedTime);
        }
      });
    }

    _setDoneBtnStatus();
  }

  void _setDoneBtnStatus() {
    setState(() {
      _doneButtonEnabled =
          bloc.selectedStartTime != null && bloc.selectedFinishTime != null;
    });
  }

  void _pickNewDate() async {
    DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: bloc.sessionDate,
      firstDate: bloc.sessionDate.subtract(Duration(days: 365)),
      lastDate: bloc.sessionDate.add(
        Duration(days: 365),
      ),
    );
    pickedDate.toUtc();
    if (pickedDate != null) {
      setState(() {
        bloc.changeDate(pickedDate);
      });
    }
  }

  void _completeTapped() async {
    AlertDialog alert;
    if (bloc.sessionForEdit.isComplete) {
      alert = AlertDialog(
        title: Text('Session is complete'),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    } else {
      alert = AlertDialog(
        title: Text('Complete this Session?'),
        content: Text('All events in this session will also be completed.'),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Complete'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                bloc.markSessionComplete();
              });
            },
          )
        ],
      );
    }

    await showDialog<bool>(
        context: (context),
        builder: (BuildContext context) {
          return alert;
        });
  }

  void _deleteSessionTapped() async {
    await showDialog<bool>(
        context: (context),
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete this Session?'),
            content: Text('All events in this session will also be deleted.'),
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
                  setState(() {
                    bloc.add(DeleteSessionWithIdEvent(
                        id: bloc.sessionForEdit.sessionId));
                  });
                },
              )
            ],
          );
        });
  }

  void _doneTapped() {
    bloc.updateSession();
  }

  void _addEvent(int eventDuration) async {
    if (eventDuration > bloc.availableTime) {
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
    } else {
      bloc.createEvent(eventDuration);

      setState(() {
        _showEventCreator = false;
      });
    }
  }

  void _cancelEventTapped() {
    setState(() {
      bloc.selectedSkill = null;
    });
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
                setState(() {
                  bloc.deleteEvent(map);
                  _doneButtonEnabled = true;
                });
              },
            )
          ],
        );
      },
    );
    Navigator.of(context).pop();
  }
}
