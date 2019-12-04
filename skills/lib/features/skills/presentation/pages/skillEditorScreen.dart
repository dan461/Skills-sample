import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/goalEditorScreen/goalEditor_bloc.dart';
// import 'package:skills/features/skills/presentation/bloc/newSkillScreen/new_skill_bloc.dart';
// import 'package:skills/features/skills/presentation/bloc/newSkillScreen/new_skill_event.dart';
import 'package:skills/features/skills/presentation/bloc/skillEditorScreen/skilleditor_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skillEditorScreen/skilleditor_event.dart';
import 'package:skills/features/skills/presentation/bloc/skillEditorScreen/skilleditor_state.dart';
// import 'package:skills/features/skills/presentation/bloc/skillEditorScreen/skilleditor_state.dart' as prefix0;
import 'package:skills/service_locator.dart';

import 'goalEditorScreen.dart';

class SkillEditorScreen extends StatefulWidget {
  final SkillEditorBloc skillEditorBloc;

  const SkillEditorScreen({Key key, @required this.skillEditorBloc})
      : super(key: key);
  @override
  _SkillEditorScreenState createState() =>
      _SkillEditorScreenState(skillEditorBloc: skillEditorBloc);
}

class _SkillEditorScreenState extends State<SkillEditorScreen> {
  final SkillEditorBloc skillEditorBloc;
  GoaleditorBloc _goalEditorBloc;
  Skill _skill;
  String goalDesc;
  Container goalArea;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _sourceController = TextEditingController();
  bool _doneEnabled = false;

  _SkillEditorScreenState({@required this.skillEditorBloc});

  @override
  void initState() {
    super.initState();

    _goalEditorBloc = locator<GoaleditorBloc>();

    goalDesc = 'Goal: none';
    goalArea = Container();
  }

  void setDoneButtonEnabled() {
    // if (skillEditorBloc.state is EditingSkillState) {
    //   setState(() {
    //     _doneEnabled = _nameController.text != _skill.name ||
    //         _sourceController.text != _skill.source;
    //   });
    // } else if (skillEditorBloc.state is CreatingNewSkillState) {
      setState(() {
        _doneEnabled = _nameController.text.isNotEmpty &&
            _sourceController.text.isNotEmpty;
      });
    // }
  }

  void _doneTapped() {
    if (skillEditorBloc.state is EditingSkillState) {
      _updateSkill();
    } else if (skillEditorBloc.state is CreatingNewSkillState) {
      _insertNewSkill();
    }
  }

  void _updateSkill() async {
    Skill updatedSkill = Skill(
        id: _skill.id,
        name: _nameController.text,
        source: _sourceController.text,
        startDate: _skill.startDate,
        totalTime: _skill.totalTime,
        currentGoalId: _skill.currentGoalId,
        goalText: _skill.goalText);

    skillEditorBloc.add(UpdateSkillEvent(updatedSkill));
  }

  void _insertNewSkill() async {
    Skill newSkill =
        Skill(name: _nameController.text, source: _sourceController.text);
    skillEditorBloc.add(InsertNewSkillEvent(newSkill));

    // Navigator.of(context).pop();
  }

  void _goToGoalEditor(int skillId) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return GoalCreationScreen(skillId: skillId, skillName: 'dkdkd');
    }));
  }

  // void _showGoalTapped() {
  //   setState(() {
  //     _showGoalEditor = !_showGoalEditor;
  //   });
  // }

  Container _skillUpdateArea(int skillId) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8.0),
              child: TextField(
                onChanged: (_) {
                  setDoneButtonEnabled();
                },
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8.0),
              child: TextField(
                onChanged: (_) {
                  setDoneButtonEnabled();
                },
                controller: _sourceController,
                decoration: InputDecoration(labelText: 'Source'),
              ),
            ),
            _goalDescriptionArea(true, skillId),
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8.0),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Add goal'),
                    onPressed: () {
                      _goToGoalEditor(skillId);
                    },
                  ),
                  RaisedButton(
                    child: Text('Schedule'),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8.0),
              child: RaisedButton(
                child: Text('Done'),
                onPressed: () {
                  // update skill with goal description and id of current goal
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _newSkillAreaBuilder() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8.0),
              child: TextField(
                onChanged: (_) {
                  setDoneButtonEnabled();
                },
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8.0),
              child: TextField(
                onChanged: (_) {
                  setDoneButtonEnabled();
                },
                controller: _sourceController,
                decoration: InputDecoration(labelText: 'Source'),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8.0),
              child: RaisedButton(
                  child: Text('Done!'),
                  onPressed: _doneEnabled
                      ? () {
                          _insertNewSkill();
                        }
                      : null),
            ),
          ],
        ),
      ),
    );
  }

  Container _skillEditingArea(Skill skill) {
    _nameController.text = skill.name;
    _sourceController.text = skill.source;

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8.0),
              child: TextField(
                onChanged: (text) {
                  _nameController.text = text;
                  setDoneButtonEnabled();
                },
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8.0),
              child: TextField(
                onChanged: (text) {
                  _sourceController.text = text;
                  setDoneButtonEnabled();
                },
                controller: _sourceController,
                decoration: InputDecoration(labelText: 'Source'),
              ),
            ),
            _goalDescriptionArea(true, skill.id),
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8.0),
              child: RaisedButton(
                child: Text('Done!'),
                onPressed: _doneEnabled
                    ? () {
                        _doneTapped();
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _goalDescriptionArea(bool withGoal, int skillId) {
    Widget body;
    if (withGoal) {
      body = Container(
        child: InkWell(
          onTap: () {
            _goToGoalEditor(skillId);
          },
          child: Container(
            color: Colors.grey[100],
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Text(
                  'fix this',
                  style: Theme.of(context).textTheme.subhead,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                )),
          ),
        ),
      );
    } else {
      body = Container();
    }

    return body;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<SkillEditorBloc>(
            builder: (BuildContext context) => skillEditorBloc),
        BlocProvider<GoaleditorBloc>(
            builder: (BuildContext context) => _goalEditorBloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('New Skill'),
          ),
        ),
        body: BlocBuilder<SkillEditorBloc, SkillEditorState>(
          builder: (context, state) {
            Widget body;

            if (state is InitialSkillEditorState ||
                state is CreatingNewSkillState) {
              body = _newSkillAreaBuilder();
            } else if (state is EditingSkillState) {
              _skill = state.skill;
              body = _skillEditingArea(_skill);
            } else if (state is NewSkillInsertedState) {
              body = _skillUpdateArea(state.newId);
            } else if (state is UpdatedSkillState) {
              body = Center(
                child: CircularProgressIndicator(),
              );
              Navigator.of(context).pop();
            } else if (state is NewSkillInsertingState ||
                state is UpdatingSkillState) {
              body = Center(
                child: CircularProgressIndicator(),
              );
            }

            return body;
          },
        ),
      ),
    );
  }
}
