import 'package:flutter/material.dart';

class DayDetails extends StatefulWidget {
  @override
  _DayDetailsState createState() => _DayDetailsState();
}

class _DayDetailsState extends State<DayDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: height / 4.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Nov. 22, 2019',
                  style: Theme.of(context).textTheme.subhead,
                ),
                Text(
                  '2 Sessions',
                  style: Theme.of(context).textTheme.subhead,
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  '3 pm to 5pm, 2 hours. 4 skills',
                  style: Theme.of(context).textTheme.subhead,
                )
              ],
            ),
          ],
        ),
      ),
      color: Colors.grey[300],
    );
  }
}
