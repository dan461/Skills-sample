import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skills/core/constants.dart';
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
      string = 'last: Never';
    } else {
      string = DateFormat.yMMMd().format(skill.lastPracDate);
    }
    return string;
  }

  TextTheme thisTheme;

  @override
  Widget build(BuildContext context) {
    thisTheme = Theme.of(context).textTheme;

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
        height: 95,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _nameRow(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _sourceRow(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _profPriorityRow(),
            ),
            // _instrumentRow(),
            _goalRow()
          ],
        ),
      ),
    );
  }

  Row _nameRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          skill.name,
          style: thisTheme.subhead,
          overflow: TextOverflow.ellipsis,
        ),
        Text(lastPracString, style: thisTheme.subtitle)
      ],
    );
  }

  Row _sourceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Source: ${skill.source}', style: thisTheme.subtitle),
        // Text(lastPracString, style: thisTheme.subtitle)
        Text('${skill.instrument}')
      ],
    );
  }

  Row _profPriorityRow() {
    var priorityString = PRIORITIES[skill.priority];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Prof: ${skill.proficiency.toInt().toString()}'),
        Text('Priority: $priorityString')
      ],
    );
  }

  Row _instrumentRow() {
    return Row(
      children: <Widget>[Text('${skill.instrument}')],
    );
  }

  Row _goalRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          skill.goalText,
          style: thisTheme.subtitle,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}
