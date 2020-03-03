import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/sessionDataScreen/sessiondata_bloc.dart';
import 'package:skills/features/skills/presentation/pages/skillsScreen.dart';
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

  bool _isEditing = false;

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
        listener: (context, state) {},
        child: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(),
              body: BlocBuilder<SessiondataBloc, SessiondataState>(
                builder: (context, state) {
                  if (state is SessiondataInitial) {
                    // TODO - showing spinner while events loading. Get events if getEvents UC hasn't been called?
                    body = Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Events loaded
                  else if (state is SessionDataEventsLoadedState) {
                    body = _contentBuilder();
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

  Widget _contentBuilder() {
    if (_isEditing)
      return _editorViewBuilder();
    else
      return _infoViewBuilder();
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
            )
            // Padding(
            //   padding: const EdgeInsets.only(top: 8.0),
            //   child: _eventsListBuilder(),
            // )
          ],
        ),
      ),
    );
  }

  void _onDoneEditing(Map<String, dynamic> changeMap){

  }

  Widget _infoViewBuilder() {
    return Container(
        child: Column(children: <Widget>[
      _infoSectionBuilder(),
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

  Column _eventsSectionBuilder() {
    return Column(
      children: <Widget>[_eventsHeaderBuilder(), _eventsListBuilder()],
    );
  }

  Widget _eventsHeaderBuilder() {
    int count =
        bloc.eventMapsForListView.isEmpty ? 0 : bloc.completedEventsCount;
    String suffix =
        bloc.eventMapsForListView.isEmpty ? 'scheduled' : 'completed';
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

// ******* ACTIONS *******

  void _onEditTapped() {
    setState(() {
      _isEditing = true;
    });
  }

  void _onCancelEdit() {
    setState(() {
      _isEditing = false;
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
                  // bloc.deleteEvent(map);
                  // _doneButtonEnabled = true;
                });
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
      // setState(() {
      //   bloc.add(SkillSelectedForExistingSessionEvent(skill: selectedSkill));
      // });
    }
  }

  void _selectSkill(Skill skill) { 
    Navigator.of(context).pop(skill);
  }
}
