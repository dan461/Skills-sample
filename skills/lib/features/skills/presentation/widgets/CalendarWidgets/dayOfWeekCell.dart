import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef DayCellTapCallback(DateTime date);

class DayOfWeekCell extends StatefulWidget {
  final DateTime date;

  final DayCellTapCallback tapCallback;
  final bool isFocused;
  final List<Widget> eventViews;

  const DayOfWeekCell(
      {Key key, this.date, this.tapCallback, this.isFocused, this.eventViews})
      : super(key: key);

  @override
  _DayOfWeekCellState createState() =>
      _DayOfWeekCellState(date, tapCallback, isFocused, eventViews);
}

class _DayOfWeekCellState extends State<DayOfWeekCell> {
  final DateTime date;

  final DayCellTapCallback tapCallback;
  final bool isFocused;
  final List<Widget> eventViews;

  _DayOfWeekCellState(
      this.date, this.tapCallback, this.isFocused, this.eventViews);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.0, color: Colors.grey[400]))),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _content(widget.date, eventViews),
          ),
        ),
      ),
    );
  }

  List<Widget> _content(DateTime date, List<Widget> views) {
    List<Widget> widgets = [];
    widgets.add(_dateBoxBuilder(date));
    if (views != null) {
      widgets.addAll(views);
    }

    return widgets;
  }

  Container _dateBoxBuilder(DateTime date) {
    return Container(
      color: isFocused ? Colors.cyan[200] : Colors.grey[200],
      margin: EdgeInsets.all(2),
      width: 60,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(DateFormat.E().format(widget.date)),
            Text(DateFormat.d().format(widget.date)),
          ],
        ),
      ),
    );
  }
}
