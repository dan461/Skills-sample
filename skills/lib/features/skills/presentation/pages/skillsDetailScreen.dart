import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skills/core/appearance.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/presentation/bloc/newSkillScreen/newskill_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skillsDetailScreen/skilldata_bloc.dart';
import 'package:skills/features/skills/presentation/widgets/completedActivitiesCell.dart';
import 'package:skills/features/skills/presentation/widgets/skillForm.dart';

import 'goalEditorScreen.dart';
import 'newGoalScreen.dart';

class SkillsDetailScreen extends StatefulWidget {
  final SkillDataBloc bloc;

  const SkillsDetailScreen({Key key, this.bloc}) : super(key: key);
  @override
  _SkillsDetailScreenState createState() => _SkillsDetailScreenState(bloc);
}

class _SkillsDetailScreenState extends State<SkillsDetailScreen> {
  final SkillDataBloc bloc;

  _SkillsDetailScreenState(this.bloc);

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

  String get goalString {
    return bloc.goal == null ? 'None' : bloc.goal.goalText;
  }

  int _sideBySideBreakpoint = 600;
  bool get showSideBySide {
    return MediaQuery.of(context).size.width > _sideBySideBreakpoint;
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
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: showSideBySide
                ? PreferredSize(
                    preferredSize: Size.zero,
                    child: Container(),
                  )
                : AppBar(
                    title: Text('Details'),
                  ),
            body: SafeArea(
              child: BlocBuilder<SkillDataBloc, SkillDataState>(
                builder: (context, state) {
                  if (state is InitialNewSkillState ||
                      state is SkillDataCrudProcessingState) {
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
                    bloc.add(
                        RefreshSkillByIdEvent(skillId: bloc.skill.skillId));
                  }

                  return body;
                },
              ),
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
              createSkillCallback: null,
              doneEditingCallback: _doneEditing,
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
      color: Theme.of(context).backgroundColor,
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
      // color: Colors.teal[300],
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
          style: Theme.of(context).textTheme.headline5,
          overflow: TextOverflow.ellipsis,
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
    String sourceString =
        skill.source.isNotEmpty ? skill.source : 'source: none';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          sourceString,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Text(
          '${skill.instrument}',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }

  Widget _eventsListBuilder() {
    return Container(
      color: Theme.of(context).backgroundColor,
      // decoration: BoxDecoration(
      //     gradient: GradientFromBottom(
      //         accentColor: Colors.cyan[800], baseColor: Colors.cyan[700])),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Text('Recent Practice Activity',
                    style: Theme.of(context).textTheme.subtitle1),
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
          color: Theme.of(context).colorScheme.secondary,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Goal: (tap to edit)'),
                  Container(
                    height: 30,
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _goToNewGoalScreen(bloc.skill.skillId, bloc.skill.name);
                      },
                    ),
                  )
                ],
              ),
              Text(
                goalString,
                style: Theme.of(context).textTheme.subtitle1,
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
            style: Theme.of(context).textTheme.subtitle1,
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
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            'Priority: $priorityString',
            style: Theme.of(context).textTheme.subtitle1,
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
            style: Theme.of(context).textTheme.subtitle1,
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
            style: Theme.of(context).textTheme.subtitle1,
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

  void _doneEditing(Map<String, dynamic> changeMap) {
    setState(() {
      bloc.add(UpdateExistingSkillEvent(
          skillId: bloc.skill.skillId, changeMap: changeMap));
      _isEditing = false;
    });
  }

  void _onActivityTapped(Activity event) {}

  void _onGoalSectionTapped(int goalId) {
    if (goalId == 0)
      _goToNewGoalScreen(bloc.skill.skillId, bloc.skill.name);
    else
      _goToGoalEditor(bloc.skill.skillId, bloc.skill.name, goalId);
  }

  void _goToNewGoalScreen(int skillId, String skillName) async {
    bool refresh =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewGoalScreen(
        skillId: skillId,
        skillName: skillName,
      );
    }));

    if (refresh != null)
      bloc.add(RefreshSkillByIdEvent(skillId: bloc.skill.skillId));
  }

  void _goToGoalEditor(int skillId, String skillName, int goalId) async {
    bool refresh =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return GoalEditorScreen(
        skillId: skillId,
        skillName: skillName,
        goalId: goalId,
      );
    }));

    if (refresh != null)
      bloc.add(RefreshSkillByIdEvent(skillId: bloc.skill.skillId));
  }
}
