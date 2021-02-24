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
    return showDetails ? 122 : 70;
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
          padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_leftConciseColumn(), _lastPracticedColumn()],
        ),
      ),
    ]);
  }

  Widget _leftConciseColumn() {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
            child: _nameRow(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
            child: _sourceRow(),
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(6, 4, 6, 2),
          //   child: _goalRow(),
          // )
        ],
      ),
    );
  }

  Column _detailsView() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_leftDetailsColumn(), _lastPracticedColumn()],
          ),
        ),
        // _goalRow()
      ],
    );
  }

  Widget _leftDetailsColumn() {
    var priorityString = PRIORITIES[skill.priority];
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
            child: _nameRow(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
            child: _sourceRow(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 3, 6, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _proficiencySection(skill.proficiency.toDouble()),
                Text('Priority: $priorityString')
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 6, 2),
            child: _goalRow(),
          )
        ],
      ),
    );
  }

  Widget _lastPracticedColumn() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.green,
              radius: 21,
              child: Text(
                "30",
                style: TextStyle(
                    fontSize: thisTheme.subtitle1.fontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              "12/30/20",
              style: thisTheme.overline,
            )
          ],
        ),
      ),
      width: 60,
      height: 54,
      // color: Colors.grey,
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
      children: [
        Expanded(
          child: Text(
            skill.name,
            style: TextStyle(
              fontSize: thisTheme.subtitle1.fontSize,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Row _sourceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[Text('${skill.source}'), Text('${skill.instrument}')],
    );
  }

  // Row _profPriorityRow() {
  //   var priorityString = PRIORITIES[skill.priority];
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: <Widget>[
  //       Text('Prof: ${skill.proficiency.toInt().toString()}/10'),
  //       Text('Priority: $priorityString')
  //     ],
  //   );
  // }

  Widget _proficiencySection(double prof) {
    prof = prof > 5 ? prof / 2 : prof;
    List stars = <Icon>[];
    int count = 1;
    while (count < 6) {
      Icon star = Icon(Icons.star_border_outlined, color: Colors.grey);
      if (prof == 0.5) {
        star = Icon(Icons.star_half, color: Color(0xFFdaa520));
      } else if (prof >= 0.5) {
        star = Icon(Icons.star, color: Color(0xFFdaa520));
      }

      stars.add(star);
      ++count;
      --prof;
    }
    return Row(
      children: stars,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }

  Row _goalRow() {
    String goalText = skill.goal != null ? skill.goal.goalText : 'None';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            goalText,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            maxLines: 1,
          ),
        )
      ],
    );
  }
}
