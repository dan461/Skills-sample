import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';

typedef EventCellCallback(Map<String, dynamic> map);

class SessionEventCell extends StatelessWidget {
  final Map<String, dynamic> map;
  final EventCellCallback callback;
  // final SkillEvent event;

  const SessionEventCell({Key key, @required this.map, @required this.callback})
      : super(key: key);

  Widget goalSectionBuilder(Skill skill, BuildContext context) {
    Widget body = SizedBox();
    var goal = map['goal'];
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
                  Text(goal.goalText, style: Theme.of(context).textTheme.body1),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('$goalTimeString min remaining',
                      style: Theme.of(context).textTheme.body1)
                ],
              )
            ],
          ),
        ),
      );
    }

    return body;
  }

  @override
  Widget build(BuildContext context) {
    String durationString = map['activity'].duration.toString();
    Skill skill = map['skill'];
    // Goal goal = map['goal'];

    return GestureDetector(
      onTap: () {
        callback(map);
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
                    Text(skill.name,
                        style: Theme.of(context).textTheme.subhead),
                    Text('$durationString min.',
                        style: Theme.of(context).textTheme.subhead),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(skill.source, style: Theme.of(context).textTheme.body1)
                  ],
                ),
                goalSectionBuilder(skill, context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
