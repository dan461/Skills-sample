import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/widgets/activitiesListSection.dart';
import 'package:skills/features/skills/presentation/widgets/sessionEventCell.dart';

class ActiveSessionActivityList extends StatefulWidget {
  final List<Activity> activities;
  final ActivitiesSectionActivityTappedCallback activityTappedCallback;

  const ActiveSessionActivityList(
      {Key key, @required this.activities, @required this.activityTappedCallback})
      : super(key: key);

  @override
  _ActiveSessionActivityListState createState() =>
      _ActiveSessionActivityListState(activities, activityTappedCallback);
}

class _ActiveSessionActivityListState extends State<ActiveSessionActivityList> {
  final List<Activity> activities;
  final ActivitiesSectionActivityTappedCallback eventTappedCallback;

  _ActiveSessionActivityListState(this.activities, this.eventTappedCallback);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[_activitiesHeaderBuilder(), _activitiesListBuilder()],
    );
  }

  Widget _activitiesHeaderBuilder() {
    String countString = activities.length.toString() + ' completed';

    return Container(
        height: 40,
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Activities', style: Theme.of(context).textTheme.subhead),
              Text('$countString', style: Theme.of(context).textTheme.subhead),
            ],
          ),
        ));
  }

  ListView _activitiesListBuilder() {
    List sourceList = activities;
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ActiveSessionCell(
          activity: sourceList[index],
          callback: _onActivityTapped,
        );
      },
      itemCount: sourceList.length,
    );
  }

  void _onActivityTapped(Activity activity) {}
}

class ActiveSessionCell extends StatefulWidget {
  final Activity activity;
  final ActivityCellCallback callback;

  const ActiveSessionCell(
      {Key key, @required this.activity, @required this.callback})
      : super(key: key);
  @override
  _ActiveSessionCellState createState() =>
      _ActiveSessionCellState(activity, callback);
}

class _ActiveSessionCellState extends State<ActiveSessionCell> {
  final Activity activity;
  final ActivityCellCallback callback;

  _ActiveSessionCellState(this.activity, this.callback);

  @override
  Widget build(BuildContext context) {
    String durationString = activity.duration.toString();
    Skill skill = activity.skill;

    return GestureDetector(
      onTap: callback(activity),
      child: Card(
        color: Colors.grey[200],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(skill.name,
                        style: Theme.of(context).textTheme.subhead),
                  ],
                ),
                Text('$durationString min.',
                    style: Theme.of(context).textTheme.subhead),
              ],
            ),
            Row(
              children: <Widget>[
                Text(skill.source, style: Theme.of(context).textTheme.body1)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
