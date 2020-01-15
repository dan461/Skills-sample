import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/pages/skillsScreen.dart';

class SkillCell extends StatelessWidget {
  final Skill skill;
  final SelectionCallback callback;
  SkillCell({@required this.skill, @required this.callback});

  String get lastPracString {
    var string;
    if (skill.lastPracDate
        .isAtSameMomentAs(DateTime.fromMicrosecondsSinceEpoch(0))) {
      string = 'Never Practiced!';
    } else {
      string = DateFormat.yMMMd().format(skill.lastPracDate);
    }
    return string;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callback(skill);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        padding: EdgeInsets.all(4),
        height: 70,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        skill.name,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(skill.source,
                          style: Theme.of(context).textTheme.subtitle),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(skill.goalText,
                          style: Theme.of(context).textTheme.subtitle)
                    ],
                  )
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Text('Last Practiced',
                    style: Theme.of(context).textTheme.subtitle),
                Text(lastPracString,
                    style: Theme.of(context).textTheme.subtitle)
              ],
            )
          ],
        ),
      ),
    );
  }
}
