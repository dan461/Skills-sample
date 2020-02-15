import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/presentation/bloc/newSkillScreen/newskill_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skillDataScreen/skilldata_bloc.dart';
import 'package:skills/features/skills/presentation/widgets/completedActivitiesCell.dart';

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
              title: Text('title'),
            ),
            body: BlocBuilder<SkillDataBloc, SkillDataState>(
              builder: (context, state) {
                if (state is InitialNewSkillState) {
                  body = Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SkillDataEventsLoadedState) {
                  body = _contentBuilder();
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
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: _nameRow(bloc.skill),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: _sourceInstrRow(bloc.skill),
            ),
            _lastPracRow(),
            _startDateRow(),
            _timeRow(bloc.skill),
            _profPrioRow(bloc.skill),
            _goalInfoRow(bloc.skill),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: _eventsListBuilder(),
            )
          ],
        ),
      ),
    );
  }

  Widget _nameRow(Skill skill) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          skill.name,
          style: Theme.of(context).textTheme.headline,
        ),
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
      decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 1.0, color: Colors.grey[400]))),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
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
    if (bloc.completedActivities.isNotEmpty){
      return ListView.builder(
        shrinkWrap: true,
        itemCount: bloc.completedActivities.length,
        itemBuilder: (context, index) {
          return CompletedActivitiesCell(
              activity: bloc.completedActivities[index],
              tapCallback: _onActivityTapped);
        });
    } else {
      return Center(child: Text('No completed activities'),);
    }
    
  }

  void _onActivityTapped(SkillEvent event) {}

  Widget _goalInfoRow(Skill skill) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        color: Colors.grey[100],
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            child: Text(
              bloc.skill.goalText,
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
}
