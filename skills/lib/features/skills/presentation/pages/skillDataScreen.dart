import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/presentation/bloc/skillDataScreen/skilldata_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }

  Widget _infoViewBuilder(Skill skill) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    skill.name,
                    style: Theme.of(context).textTheme.headline,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
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
              ),
            ),
            _lastPracRow(),
            _startDateRow(),
            _timeRow(skill),
            _profPrioRow(skill),
            _goalInfoRow(skill),
            _eventsListBuilder()
          ],
        ),
      ),
    );
  }

  Widget _eventsListBuilder(){
    return Column(
      children: <Widget>[
        Text('Recent Events')
      ],
    );
  }

  Widget _goalInfoRow(Skill skill) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        color: Colors.grey[100],
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            child: Text(
              skill.goalText,
              style: Theme.of(context).textTheme.subhead,
              maxLines: 2,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            )),
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
            'Total time: ${skill.totalTime.toString()} min.',
            style: Theme.of(context).textTheme.subhead,
          ),
        ],
      ),
    );
  }

  Widget _profPrioRow(Skill skill) {
    var priorityString = PRIORITIES[skill.priority];
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Proficiency: ${skill.proficiency.toString()}/10',
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
}