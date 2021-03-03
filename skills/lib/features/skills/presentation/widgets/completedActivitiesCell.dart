import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';

typedef CompletedActivityCellCallback(Activity activity);

class CompletedActivitiesCell extends StatelessWidget {
  final Activity activity;
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
                        style: Theme.of(context).textTheme.subtitle1),
                    Text('$durationString min.',
                        style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Notes: This is where the notes would go.',
                        style: Theme.of(context).textTheme.bodyText2),
                  ],
                ),
              ])),
        ),
      ),
    );
  }
}
