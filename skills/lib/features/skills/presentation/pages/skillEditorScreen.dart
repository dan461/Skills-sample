import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/skillEditorScreen/skilleditor_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skillEditorScreen/skilleditor_event.dart';
import 'package:skills/features/skills/presentation/bloc/skillEditorScreen/skilleditor_state.dart';
import 'goalEditorScreen.dart';
import 'newGoalScreen.dart';

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

  Skill _skill;
  String goalDesc;
  Container goalArea;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _sourceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  _SkillEditorScreenState({@required this.skillEditorBloc});

  @override
  void initState() {
    super.initState();

    goalDesc = 'Goal: none';
    goalArea = Container();
  }

  @override
  dispose() {
    super.dispose();
  }

  bool get _doneEnabled {
    bool shouldEnable;
    if (skillEditorBloc.state is EditingSkillState) {
      shouldEnable = _nameController.text != _skill.name ||
          _sourceController.text != _skill.source;
    } else if (skillEditorBloc.state is CreatingNewSkillState) {
      shouldEnable =
          _nameController.text.isNotEmpty && _sourceController.text.isNotEmpty;
    }
    //  return shouldEnable;

    return true;
  }

  void setDoneButtonEnabled() {
    bool shouldEnable;
    if (skillEditorBloc.state is EditingSkillState) {
      shouldEnable = _nameController.text != _skill.name ||
          _sourceController.text != _skill.source;
    } else if (skillEditorBloc.state is CreatingNewSkillState) {
      shouldEnable =
          _nameController.text.isNotEmpty && _sourceController.text.isNotEmpty;
    }

    if (_doneEnabled != shouldEnable) {
      setState(() {
        // _doneEnabled = shouldEnable;
      });
    }
  }

  void _doneTapped() {
    if (skillEditorBloc.state is EditingSkillState) {
      _updateSkill();
    } else if (skillEditorBloc.state is CreatingNewSkillState) {
      _insertNewSkill();
    }
  }

  void _deleteTapped() async {
    await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete this Skill?'),
            content: Text(
              'Deleting this Skill will also delete any goals associated with it. Any past events of this Skill will remain.',
            ),
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
                  _deleteSkill();
                },
              )
            ],
          );
        });
  }

  void _deleteSkill() async {
    skillEditorBloc.add(DeleteSkillWithIdEvent(skillId: _skill.skillId));
  }

  void _updateSkill() async {
    Skill updatedSkill = Skill(
        skillId: _skill.skillId,
        name: _nameController.text,
        source: _sourceController.text,
        startDate: _skill.startDate,
        totalTime: _skill.totalTime,
        lastPracDate: _skill.lastPracDate,
        currentGoalId: _skill.currentGoalId,
        goalText: _skill.goalText);

    skillEditorBloc.add(UpdateSkillEvent(skill: updatedSkill));
  }

  void _insertNewSkill() async {
    Skill newSkill =
        Skill(name: _nameController.text, source: _sourceController.text);
    skillEditorBloc.add(InsertNewSkillEvent(newSkill));
  }

  void _createOrEditGoal() {
    if (_skill.currentGoalId == 0) {
      _goToNewGoalScreen(_skill.skillId, _skill.name);
    } else {
      _goToGoalEditor(_skill.skillId, _skill.name, _skill.currentGoalId);
    }
  }

  void _goToNewGoalScreen(int skillId, String skillName) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewGoalScreen(
        skillId: skillId,
        skillName: skillName,
      );
    }));

    skillEditorBloc.add(GetSkillByIdEvent(id: skillId));
  }

  void _goToGoalEditor(int skillId, String skillName, int goalId) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return GoalEditorScreen(
        skillId: skillId,
        skillName: skillName,
        goalId: goalId,
      );
    }));

    skillEditorBloc.add(GetSkillByIdEvent(id: skillId));
  }

  Form _skillEditFormBuilder(Key formKey) {
    return Form(
      autovalidate: true,
      key: formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (_) {
                setDoneButtonEnabled();
              },
              validator: (value) {
                // _doneEnabled =
                //     value.isNotEmpty && _sourceController.text.isNotEmpty;
                if (value.isEmpty) {
                  // _doneEnabled = false;
                  return 'Name Required';
                } else
                  return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _sourceController,
              decoration: InputDecoration(labelText: 'Source'),
              onChanged: (_) {
                setDoneButtonEnabled();
              },
              validator: (value) {
                // _doneEnabled =
                //     value.isNotEmpty && _nameController.text.isNotEmpty;
                if (value.isEmpty) {
                  return 'Source Required';
                } else
                  return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 8.0),
            child: RaisedButton(
                child: Text('Done!'),
                onPressed: _doneEnabled
                    ? () {
                        _doneTapped();
                      }
                    : null),
          ),
        ],
      ),
    );
  }

  Container _newSkillAreaBuilder() {
    return Container(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          child: _skillEditFormBuilder(_formKey)),
    );
  }

  Container _skillEditingArea(Skill skill) {
    // _nameController.text = skill.name;
    // _sourceController.text = skill.source;

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8.0),
              child: TextField(
                autocorrect: false,
                onChanged: (text) {
                  _nameController.text = text;
                  // setDoneButtonEnabled();
                  // print('Text: $text');
                },
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text: _nameController.text,
                    selection: TextSelection.collapsed(
                        offset: _nameController.text.length),
                  ),
                ),
                decoration: InputDecoration(labelText: 'Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8.0),
              child: TextField(
                onChanged: (text) {
                  _sourceController.text = text;
                  // setDoneButtonEnabled();
                },
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text: _sourceController.text,
                    selection: TextSelection.collapsed(
                        offset: _sourceController.text.length),
                  ),
                ),
                decoration: InputDecoration(labelText: 'Source'),
              ),
            ),
            _goalDescriptionArea(true, skill.skillId),
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8.0),
              child: RaisedButton(
                child: Text('Done'),
                onPressed: _doneEnabled
                    ? () {
                        _doneTapped();
                      }
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8.0),
              child: RaisedButton(
                child: Text('Delete'),
                onPressed: () {
                  _deleteTapped();
                },
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
            _createOrEditGoal();
            // _goToGoalEditor(skillId, _skill.name, _skill.currentGoalId);
          },
          child: Container(
            color: Colors.grey[100],
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Text(
                  _skill.goalText,
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
    return BlocProvider(
      builder: (BuildContext context) => skillEditorBloc,
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
              // Editing
            } else if (state is EditingSkillState) {
              _skill = state.skill;
              _nameController.text = _skill.name;
              _sourceController.text = _skill.source;
              body = _skillEditingArea(_skill);
            } else if (state is SkillRetrievedForEditingState) {
              _skill = state.skill;
              body = _skillEditingArea(_skill);
              // Skill updated
            } else if (state is UpdatedSkillState ||
                state is DeletedSkillWithIdState) {
              body = Center(
                child: CircularProgressIndicator(),
              );
              Navigator.of(context).pop();
              // Procressing
            } else if (state is NewSkillInsertingState ||
                state is UpdatingSkillState ||
                state is DeletingSkillWithIdState ||
                state is SkillEditorCrudInProgressState) {
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
