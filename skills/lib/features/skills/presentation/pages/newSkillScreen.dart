// import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/newSkillScreen/new_skill_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/newSkillScreen/new_skill_event.dart';
import 'package:skills/features/skills/presentation/bloc/newSkillScreen/new_skill_state.dart';
import 'package:skills/service_locator.dart';

import 'goalEditorScreen.dart';

class NewSkillScreen extends StatefulWidget {
  @override
  _NewSkillScreenState createState() => _NewSkillScreenState();
}

class _NewSkillScreenState extends State<NewSkillScreen> {
  NewSkillBloc _bloc;
  bool _goalAdded;

  @override
  void initState() {
    super.initState();
    _bloc = locator<NewSkillBloc>();
    _goalAdded = false;
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _sourceController = TextEditingController();
  bool _doneEnabled = false;

  void setDoneButtonEnabled() {
    setState(() {
      _doneEnabled =
          _nameController.text.isNotEmpty && _sourceController.text.isNotEmpty;
    });
  }

  void _insertNewSkill() async {
    Skill newSkill =
        Skill(name: _nameController.text, source: _sourceController.text);
    _bloc.add(InsertNewSkillEvent(newSkill));

    // Navigator.of(context).pop();
  }

  void _goToGoalEditor() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return GoalCreationScreen();
    }));
  }

  Container _skillUpdateArea() {
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
            _goalDescriptionArea(_goalAdded),
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8.0),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Add goal'),
                    onPressed: () {
                      _goToGoalEditor();
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
                onPressed: () {},
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
                  child: Text('Done'),
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

  Container _goalDescriptionArea(bool withGoal) {
    String desc =
        'Goal: 5 hrs from 11/15 to 11/21 sll laljjdl jlgjlj  jallj agjlasljl ';

    Widget body;
    if (withGoal) {
      body = Container(
        color: Colors.grey[100],
        child: InkWell(
          onTap: () {
            _goToGoalEditor();
          },
          child: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Text(
                desc,
                style: Theme.of(context).textTheme.subhead,
                maxLines: 2,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              )),
        ),
      );
    } else {
      body = Container();
    }

    return body;
  }

  @override
  Widget build(BuildContext context) {
    // TODO - testing/layout only
    _goalAdded = true;

    return BlocProvider(
        builder: (_) => _bloc,
        child: Scaffold(
            appBar: AppBar(
              title: Center(
                child: Text('New Skill'),
              ),
            ),
            body: BlocBuilder<NewSkillBloc, NewSkillState>(
              builder: (context, state) {
                Widget body;
                if (state is EmptyNewSkillState) {
                  // body = _newSkillAreaBuilder();
                  body = _skillUpdateArea();
                } else if (state is NewSkillInsertedState) {
                  body = _skillUpdateArea();
                }
                return body;
              },
            )));
  }
}
