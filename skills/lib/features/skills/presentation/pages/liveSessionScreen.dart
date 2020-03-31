import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/liveSessionScreen/liveSessionScreen_bloc.dart';
import 'package:skills/features/skills/presentation/widgets/activeSessionActivitiesList.dart';
import 'package:skills/features/skills/presentation/widgets/stopwatch.dart';

import '../../../../service_locator.dart';

class LiveSessionScreen extends StatefulWidget {
  @override
  _LiveSessionScreenState createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen> {
  LiveSessionScreenBloc bloc;

  @override
  void initState() {
    bloc = locator<LiveSessionScreenBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => bloc,
      child: BlocListener<LiveSessionScreenBloc, LiveSessionScreenState>(
        bloc: bloc,
        listener: (context, state) {},
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Live Session'),
            ),
            body: BlocBuilder<LiveSessionScreenBloc, LiveSessionScreenState>(
                builder: (context, state) {
              Widget body;
              if (state is LiveSessionScreenInitial) {
                body = _selectionView();
              }

              return body;
            }),
          );
        }),
      ),
    );
  }

  Column _stopwatchView() {
    List<Widget> content = [_dateTimeRow(), _timeTrackRow()];

    // if (bloc.activities.length > 0){
    content.add(_activitiesSection());
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: content,
    );
  }

  Widget _timeTrackRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StopwatchWidget(
            finishedCallback: _onStopwatchFinished,
            cancelCallback: _onStopwatchCancelled,
          ),
        )
      ],
    );
  }

  Column _selectionView() {
    List<Widget> content = [_dateTimeRow(), _selectionRow()];

    //  if (bloc.activities.length > 0){
    //   content.add(_activitiesSection());
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: content,
    );
  }

  Widget _dateTimeRow() {
    return Container(
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Mar. 28, 2020', style: Theme.of(context).textTheme.title),
          Text('7:10 pm', style: Theme.of(context).textTheme.title)
        ],
      ),
    );
  }

  Widget _selectionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          child: Text('Select a skill to get started.'),
          onPressed: _showSkillsList,
          textColor: Colors.blueAccent,
        ),
      ],
    );
  }

  Widget _activitiesSection() {
    Skill skill = Skill(
        name: 'Bouree in E minor',
        type: 'Comp',
        startDate: DateTime.utc(2020, 3, 28),
        source: 'Bach');
    Activity act = Activity(
        skillId: 1,
        sessionId: 1,
        date: DateTime.utc(2020, 3, 28),
        duration: 30,
        isComplete: true,
        skillString: 'Skill description string');
    act.skill = skill;
    List<Activity> acts = [act];

    return ActiveSessionActivityList(
        activities: acts, activityTappedCallback: _onActivityTapped);
  }

  void _onActivityTapped(Activity activity) {}

  void _showSkillsList() {}

  void _onStopwatchFinished(int elapsedTime) {}

  void _onStopwatchCancelled() {}
}
