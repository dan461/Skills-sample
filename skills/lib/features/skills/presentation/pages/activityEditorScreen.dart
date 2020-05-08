import 'package:flutter/material.dart';
import 'package:skills/core/stringConstants.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/actvityEditor/activityeditor_bloc.dart';
import 'package:skills/features/skills/presentation/pages/skillsScreen.dart';
import 'package:skills/features/skills/presentation/widgets/notesFormField.dart';

class ActivityEditorScreen extends StatefulWidget {
  final ActivityEditorBloc bloc;

  const ActivityEditorScreen({Key key, @required this.bloc}) : super(key: key);

  @override
  _ActivityEditorScreenState createState() => _ActivityEditorScreenState(bloc);
}

class _ActivityEditorScreenState extends State<ActivityEditorScreen> {
  final ActivityEditorBloc bloc;
  TextEditingController _notesController = TextEditingController();
  TextEditingController _eventDurationTextControl = TextEditingController();

  _ActivityEditorScreenState(this.bloc) {
    _notesController.text = bloc.activity.notes;
  }

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
                          child: Text(bloc.activity.skill.name,
                              style: Theme.of(context).textTheme.title)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(bloc.activity.skill.source, style: Theme.of(context).textTheme.subtitle)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 100,
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        DURATION_COLON,
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 4),
                          child: TextField(
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            controller: _eventDurationTextControl,
                            onChanged: (_) {
                              // _setAddButtonEnabled();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: NotesFormField(_notesController, NOTES),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showActivitiesList() async {
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
  }

  void _selectSkill(Skill skill) {
    Navigator.of(context).pop(skill);
  }
}
