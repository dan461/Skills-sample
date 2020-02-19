import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skills/core/enums.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/presentation/bloc/newSkillScreen/newskill_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skillDataScreen/skilldata_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skillEditorScreen/skilleditor_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skillEditorScreen/skilleditor_event.dart';
import 'package:skills/features/skills/presentation/widgets/completedActivitiesCell.dart';
import 'package:skills/features/skills/presentation/widgets/skillForm.dart';
import 'package:skills/service_locator.dart';

import 'goalEditorScreen.dart';
import 'newGoalScreen.dart';

class SkillDataScreen extends StatefulWidget {
  final SkillDataBloc bloc;

  const SkillDataScreen({Key key, this.bloc}) : super(key: key);
  @override
  _SkillDataScreenState createState() => _SkillDataScreenState(bloc);
}

class _SkillDataScreenState extends State<SkillDataScreen> {
  final SkillDataBloc bloc;

  _SkillDataScreenState(this.bloc);

  String get lastPracString {
    var string;
    if (bloc.skill.lastPracDate
        .isAtSameMomentAs(DateTime.fromMicrosecondsSinceEpoch(0))) {
      string = NEVER_PRACTICED;
    } else {
      string = DateFormat.yMMMd().format(bloc.skill.lastPracDate);
    }
    return string;
  }

  String get startDateString {
    return DateFormat.yMMMd().format(bloc.skill.startDate);
  }

  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    Widget body;
    return BlocProvider(
      builder: (context) => bloc,
      child: BlocListener<SkillDataBloc, SkillDataState>(
        bloc: bloc,
        listener: (context, state) {
          // if (state is )
        },
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(bloc.skill.type),
            ),
            body: BlocBuilder<SkillDataBloc, SkillDataState>(
              builder: (context, state) {
                if (state is InitialNewSkillState ||
                    state is SkillDataGettingEventsState) {
                  body = Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // Events loaded || Skill refreshed
                else if (state is SkillDataEventsLoadedState ||
                    state is SkillRefreshedState) {
                  body = _contentBuilder();
                }
                // Skill updated
                else if (state is UpdatedExistingSkillState) {
                  body = Center(
                    child: CircularProgressIndicator(),
                  );
                  bloc.add(RefreshSkillByIdEvent(skillId: bloc.skill.skillId));
                }

                return body;
              },
            ),
          );
        }),
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
            SkillForm(
              skill: bloc.skill,
              cancelCallback: _cancelEditing,
              doneCallback: _doneEditing,
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 8.0),
            //   child: _eventsListBuilder(),
            // )
          ],
        ),
      ),
    );
  }

  Widget _infoViewBuilder() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _infoSectionBuilder(),
          _goalInfoRow(bloc.skill),
          Expanded(
            child: _eventsListBuilder(),
          )
        ],
      ),
    );
  }

  Widget _infoSectionBuilder() {
    return Container(
      color: Colors.teal[300],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _nameRow(bloc.skill),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: _sourceInstrRow(bloc.skill),
            ),
            _lastPracRow(),
            _startDateRow(),
            _timeRow(bloc.skill),
            _profPrioRow(bloc.skill),
          ],
        ),
      ),
    );
  }

  Widget _nameRow(Skill skill) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          skill.name,
          style: Theme.of(context).textTheme.headline,
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

  Widget _sourceInstrRow(Skill skill) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          skill.source,
          style: Theme.of(context).textTheme.subhead,
        ),
        Text(
          '${skill.instrument}',
          style: Theme.of(context).textTheme.subhead,
        ),
      ],
    );
  }

  Widget _eventsListBuilder() {
    return Container(
      color: Colors.cyan[200],
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Text('Recent Practice Activity',
                    style: Theme.of(context).textTheme.subhead),
              ],
            ),
          ),
          _completedEventsList()
        ],
      ),
    );
  }

  Widget _completedEventsList() {
    if (bloc.completedActivities.isNotEmpty) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: bloc.completedActivities.length,
          itemBuilder: (context, index) {
            return CompletedActivitiesCell(
                activity: bloc.completedActivities[index],
                tapCallback: _onActivityTapped);
          });
    } else {
      return Center(
        child: Text('No completed activities'),
      );
    }
  }

  Widget _goalInfoRow(Skill skill) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue[200],
          border: Border(
              top: BorderSide(width: 0.0, color: Colors.grey[400]),
              bottom: BorderSide(width: 0.0, color: Colors.grey[400]))),
      // alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: GestureDetector(
          onTap: () {
            _onGoalSectionTapped(bloc.skill.currentGoalId);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[Text('Goal: (tap to edit)')],
              ),
              Text(
                bloc.skill.goalText,
                style: Theme.of(context).textTheme.subhead,
                maxLines: 2,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeRow(Skill skill) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Total time: ${bloc.skill.totalTime.toString()} min.',
            style: Theme.of(context).textTheme.subhead,
          ),
        ],
      ),
    );
  }

  Widget _profPrioRow(Skill skill) {
    var priorityString = PRIORITIES[bloc.skill.priority];
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Proficiency: ${bloc.skill.proficiency.toString()}/10',
            style: Theme.of(context).textTheme.subhead,
          ),
          Text(
            'Priority: $priorityString',
            style: Theme.of(context).textTheme.subhead,
          ),
        ],
      ),
    );
  }

  Widget _lastPracRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Last practice: $lastPracString',
            style: Theme.of(context).textTheme.subhead,
          ),
        ],
      ),
    );
  }

  Widget _startDateRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Start Date: $startDateString',
            style: Theme.of(context).textTheme.subhead,
          ),
        ],
      ),
    );
  }

  // ACTIONS

  void _onEditTapped() {
    setState(() {
      _isEditing = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
  }

  void _doneEditing(Skill skill) {
    setState(() {
      bloc.add(UpdateExistingSkillEvent(skill: skill));
      _isEditing = false;
    });
  }

  void _onActivityTapped(SkillEvent event) {}

  void _onGoalSectionTapped(int goalId) {
    if (goalId == 0)
      _goToNewGoalScreen(bloc.skill.skillId, bloc.skill.name);
    else
      _goToGoalEditor(bloc.skill.skillId, bloc.skill.name, goalId);
  }

  void _goToNewGoalScreen(int skillId, String skillName) async {
    // bool refresh = false;
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewGoalScreen(
        skillId: skillId,
        skillName: skillName,
      );
    }));
    locator<SkillEditorBloc>().add(GetSkillByIdEvent(id: skillId));

    // TODO - make this conditional
    bloc.add(RefreshSkillByIdEvent(skillId: bloc.skill.skillId));
  }

  void _goToGoalEditor(int skillId, String skillName, int goalId) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return GoalEditorScreen(
        skillId: skillId,
        skillName: skillName,
        goalId: goalId,
      );
    }));

    locator<SkillEditorBloc>().add(GetSkillByIdEvent(id: skillId));
    // TODO - make this conditional
    bloc.add(RefreshSkillByIdEvent(skillId: bloc.skill.skillId));
  }
}
