import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';

typedef ActivityCellCallback(Activity activity);

class SessionEventCell extends StatelessWidget {
  final Activity activity;
  final ActivityCellCallback callback;
  // final SkillEvent event;

  const SessionEventCell(
      {Key key, @required this.activity, @required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String durationString = activity.duration.toString();
    Skill skill = activity.skill;
    // Goal goal = map['goal'];

    return GestureDetector(
      onTap: () {
        callback(activity);
      },
      child: Card(
        color: Colors.amber[300],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(skill.name,
                            style: Theme.of(context).textTheme.subtitle1),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: _completedIcon(),
                        )
                      ],
                    ),
                    Text('$durationString min.',
                        style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(skill.source,
                        style: Theme.of(context).textTheme.bodyText2)
                  ],
                ),
                goalSectionBuilder(skill, context),
                _notesSectionBuilder(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _completedIcon() {
    if (activity.isComplete) {
      return Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 16,
      );
    } else
      return SizedBox();
  }

  Widget _notesSectionBuilder(BuildContext context) {
    Widget section;
    if (activity.notes == null || activity.notes.isEmpty) {
      section = SizedBox();
    } else {
      section = Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'Notes: ' + activity.notes,
              style: Theme.of(context).textTheme.bodyText2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      );
    }

    return section;
  }

  Widget goalSectionBuilder(Skill skill, BuildContext context) {
    Widget body = SizedBox();
    var goal = activity.skill.goal;
    if (goal is Goal) {
      String goalTimeString = goal.timeRemaining.toString();
      body = Card(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(goal.goalText,
                      style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('$goalTimeString min remaining',
                      style: Theme.of(context).textTheme.bodyText2)
                ],
              )
            ],
          ),
        ),
      );
    }

    return body;
  }
}
