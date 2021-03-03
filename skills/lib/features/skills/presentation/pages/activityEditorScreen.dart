import 'package:flutter/material.dart';
import 'package:skills/core/stringConstants.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/actvityEditor/activityeditor_bloc.dart';
import 'package:skills/features/skills/presentation/pages/skillsMasterScreen.dart';
import 'package:skills/features/skills/presentation/widgets/CancelDoneButtonBar.dart';
import 'package:skills/features/skills/presentation/widgets/notesFormField.dart';

class ActivityEditorScreen extends StatefulWidget {
  final ActivityEditorBloc bloc;
  final int availableTime;

  const ActivityEditorScreen(
      {Key key, @required this.bloc, @required this.availableTime})
      : super(key: key);

  @override
  _ActivityEditorScreenState createState() => _ActivityEditorScreenState(bloc);
}

class _ActivityEditorScreenState extends State<ActivityEditorScreen> {
  final ActivityEditorBloc bloc;
  TextEditingController _notesController = TextEditingController();
  TextEditingController _eventDurationTextControl = TextEditingController();

  _ActivityEditorScreenState(this.bloc) {
    _notesController.text = bloc.activity.notes;
    _notesController.addListener(_notesChangeListener);
    _eventDurationTextControl.text = bloc.activity.duration.toString();
    _eventDurationTextControl.addListener(_durationChangeListener);
  }

  Skill get displayedSkill {
    if (bloc.selectedSkill != null)
      return bloc.selectedSkill;
    else
      return bloc.activity.skill;
  }

  // CHANGE LISTENERS
  void _notesChangeListener() {
    bloc.selectedNotes = _notesController.text;
    _setDoneEnabled();
  }

  void _durationChangeListener() {
    // int duration = int.parse(_eventDurationTextControl.text);
    // if (duration >= 5 &&
    //     duration <= bloc.activity.duration + widget.availableTime) {
    //   bloc.selectedDuration = duration;
    // } else {
    //   bloc.selectedDuration = bloc.activity.duration;
    //   // _eventDurationTextControl.text = bloc.activity.duration.toString();
    // }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _eventDurationTextControl.dispose();
    super.dispose();
  }

  bool _doneEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1.0, color: Colors.black))),
                      child: GestureDetector(
                          onTap: _showActivitiesList,
                          child: Text(displayedSkill.name,
                              style: Theme.of(context).textTheme.headline6)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(displayedSkill.source,
                        style: Theme.of(context).textTheme.subtitle2)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 150,
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        DURATION_COLON,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 4),
                          child: TextField(
                            textAlign: TextAlign.center,
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            controller: _eventDurationTextControl,
                            onChanged: (value) {
                              _onDurationValueChange(value);
                            },
                          ),
                        ),
                      ),
                      Text(
                        MINUTES_ABBR,
                        style: Theme.of(context).textTheme.subtitle1,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: NotesFormField(_notesController, NOTES),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CancelDoneButtonBar(
                      onDone: _onDoneTapped,
                      onCancel: _onCancelTapped,
                      doneEnabled: _doneEnabled)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onDurationValueChange(String value) {
    if (value.isNotEmpty) {
      bloc.selectedDuration = int.parse(value);
      _setDoneEnabled();
    } else {
      setState(() {
        _doneEnabled = false;
      });
    }
  }

  void _showActivitiesList() async {
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
      bloc.selectedSkill = selectedSkill;
      _setDoneEnabled();
    }
  }

  void _selectSkill(Skill skill) {
    Navigator.of(context).pop(skill);
  }

  void _setDoneEnabled() {
    setState(() {
      _doneEnabled = bloc.hasValidChanges;
    });
  }

  void _onDoneTapped() {
    bloc.add(ActivityEditorSaveEvent());
  }

  void _onCancelTapped() {
    if (bloc.hasValidChanges) {
      _showCancelDialog();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _showCancelDialog() async {
    await showDialog(
        context: (context),
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(DISCARD_CHANGES),
            content: Text(LOSE_CHANGES),
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
                  _cancel();
                },
              ),
            ],
          );
        });
  }

  void _cancel() {
    Navigator.of(context).pop();
  }
}
