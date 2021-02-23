import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/textStyles.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/pages/skillsScreen.dart';

class SkillCell extends StatelessWidget {
  final Skill skill;
  final SelectionCallback callback;
  final bool showDetails;
  SkillCell(
      {@required this.skill,
      @required this.callback,
      @required this.showDetails});
  // bool showDetails = false;
  String get lastPracString {
    var string;
    if (skill.lastPracDate
        .isAtSameMomentAs(DateTime.fromMicrosecondsSinceEpoch(0))) {
      string = NEVER_PRACTICED;
    } else {
      string = DateFormat.yMMMd().format(skill.lastPracDate);
    }
    return string;
  }

  bool get showPracticeAlert {
    return lastPracString == NEVER_PRACTICED;
  }

  double get _cellHeight {
    return showDetails ? 100 : 75;
  }

  TextTheme thisTheme;

  @override
  Widget build(BuildContext context) {
    thisTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        callback(skill);
      },
      child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Card(
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6))),
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
              height: _cellHeight,
              child: showDetails ? _detailsView() : _conciseView(),
            ),
            elevation: 2,
          )),
    );
  }

  Column _conciseView() {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Text(
              skill.name,
              style: TextStyle(
                  fontSize: thisTheme.subtitle1.fontSize,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${skill.source}'),
            Text(lastPracString,
                style: lastPracString == NEVER_PRACTICED
                    ? TextStyles.subtitleRedStyle
                    : thisTheme.subtitle2)
          ],
        ),
      ),
      _goalRow()
    ]);
  }

  Column _detailsView() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_leftDetailsColumn(), _rightDetailsColumn()],
          ),
        ),
        _goalRow()
      ],
    );
  }

  Column _leftDetailsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            skill.name,
            style: TextStyle(
                fontSize: thisTheme.subtitle1.fontSize,
                fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text('${skill.source}'),
        ),
        Text('Prof: ${skill.proficiency.toInt().toString()}/10'),
      ],
    );
  }

  Column _rightDetailsColumn() {
    var priorityString = PRIORITIES[skill.priority];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 4),
          child: Text(lastPracString,
              style: lastPracString == NEVER_PRACTICED
                  ? TextStyles.subtitleRedStyle
                  : thisTheme.subtitle2),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text('${skill.instrument}'),
        ),
        Text('Priority: $priorityString')
      ],
    );
  }

  Row _nameRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          skill.name,
          style: TextStyle(
              fontSize: thisTheme.subtitle1.fontSize,
              fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        Text(lastPracString,
            style: lastPracString == NEVER_PRACTICED
                ? TextStyles.subtitleRedStyle
                : thisTheme.subtitle2)
      ],
    );
  }

  Row _sourceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('${skill.source}'),
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
        Text('Prof: ${skill.proficiency.toInt().toString()}/10'),
        Text('Priority: $priorityString')
      ],
    );
  }

  // Row _instrumentRow() {
  //   return Row(
  //     children: <Widget>[Text('${skill.instrument}')],
  //   );
  // }

  Row _goalRow() {
    String goalText = skill.goal != null ? skill.goal.goalText : 'None';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          goalText,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}
