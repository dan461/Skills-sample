import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/newSkillScreen/newskill_bloc.dart';
import 'package:skills/features/skills/presentation/widgets/skillForm.dart';

class NewSkillScreen extends StatefulWidget {
  final NewskillBloc bloc;

  const NewSkillScreen({Key key, @required this.bloc}) : super(key: key);

  @override
  _NewSkillScreenState createState() => _NewSkillScreenState(bloc);
}

class _NewSkillScreenState extends State<NewSkillScreen> {
  final NewskillBloc bloc;

  _NewSkillScreenState(this.bloc);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (BuildContext context) => bloc,
        child: BlocListener<NewskillBloc, NewSkillState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is NewSkillInsertedState) {
              Navigator.of(context).pop();
            }
          },
          child: Builder(builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: Center(
                  child: Text('New Skill'),
                ),
              ),
              body: BlocBuilder<NewskillBloc, NewSkillState>(
                  builder: (context, state) {
                Widget body;
                if (state is InitialNewSkillState ||
                    state is NewSkillInsertedState) {
                  body = _newSkillFormBuilder();
                } else if (state is CreatingNewSkillState) {
                  body = Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return body;
              }),
            );
          }),
        ));
  }

  // BUILDERS

  Widget _newSkillFormBuilder() {
    return SkillForm(
        cancelCallback: _onCancel,
        createSkillCallback: _insertNewSkill,
        doneEditingCallback: null);
  }

// ACTIONS

  void setDoneButtonEnabled() {}

  void _insertNewSkill(Skill newSkill) async {
    bloc.add(CreateNewSkillEvent(newSkill));
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }
}
