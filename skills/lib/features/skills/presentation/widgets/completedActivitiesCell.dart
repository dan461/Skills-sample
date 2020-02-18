import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';

typedef CompletedActivityCellCallback(SkillEvent activity);

class CompletedActivitiesCell extends StatelessWidget {
  final SkillEvent activity;
  final CompletedActivityCellCallback tapCallback;

  const CompletedActivitiesCell(
      {Key key, @required this.activity, @required this.tapCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String durationString = activity.duration.toString();
    String dateString = DateFormat.yMMMd().format(activity.date);
    return GestureDetector(
      onTap: () {
        tapCallback(activity);
      },
      child: Card(
        color: Colors.cyan[100],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Container(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('$dateString',
                        style: Theme.of(context).textTheme.subhead),
                    Text('$durationString min.',
                        style: Theme.of(context).textTheme.subhead),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Notes: This is where the notes would go.',
                        style: Theme.of(context).textTheme.body1),
                  ],
                ),
              ])),
        ),
      ),
    );
  }
}
