import 'package:flutter/material.dart';
import 'package:skills/core/tickTock.dart';
import 'package:skills/features/skills/presentation/widgets/CalendarWidgets/calendarControl.dart';
import 'daysRow.dart';
import 'dayCell.dart';

class Calendar extends StatefulWidget {
  final Function tapCallback;
  final Function monthChangeCallback;
  // final List<DateTime> eventDates;
  // final DateTime activeMonth;
  final CalendarControl control;

  const Calendar(
      {Key key,
      // this.activeMonth,
      @required this.tapCallback,
      @required this.monthChangeCallback,
      @required this.control
      // this.eventDates,
      })
      : super(key: key);

  @override
  _CalendarState createState() =>
      _CalendarState(tapCallback, monthChangeCallback, control);
}

class _CalendarState extends State<Calendar>
    with SingleTickerProviderStateMixin {
  double monthHeight;
  // final DateTime activeMonth;
  // final List<DateTime> eventDates;
  final CalendarControl control;
  final Function tapCallback;
  final Function monthChangeCallback;

  // DateTime control.visiblePeriod;
  int pageId = 0;

  double detailsHeight = 0.0;

  _CalendarState(this.tapCallback, this.monthChangeCallback, this.control);

  @override
  initState() {
    super.initState();
  }

  String monthString(int month) {
    String monthString = '';
    switch (month) {
      case 1:
        {
          monthString = 'January';
        }
        break;

      case 2:
        {
          monthString = 'February';
        }
        break;

      case 3:
        {
          monthString = 'March';
        }
        break;

      case 4:
        {
          monthString = 'April';
        }
        break;

      case 5:
        {
          monthString = 'May';
        }
        break;

      case 6:
        {
          monthString = 'June';
        }
        break;

      case 7:
        {
          monthString = 'July';
        }
        break;

      case 8:
        {
          monthString = 'August';
        }
        break;

      case 9:
        {
          monthString = 'September';
        }
        break;

      case 10:
        {
          monthString = 'October';
        }
        break;

      case 11:
        {
          monthString = 'November';
        }
        break;

      case 12:
        {
          monthString = 'December';
        }
        break;
    }

    return monthString;
  }

  int testCount = 0;

  @override
  Widget build(BuildContext context) {
    monthHeight = MediaQuery.of(context).size.height / 2.25;
    return AnimatedSize(
      duration: Duration(milliseconds: 330),
      curve: Curves.fastOutSlowIn,
      alignment: Alignment(0, -1),
      vsync: this,
      child: _calendarBuilder(),
    );
  }

  /*          **********
                  ******* BUILDERS **************
              **********
  */

  Column _calendarBuilder() {
    List<Widget> calendarWidgets = [
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: _modeBarBuilder(),
      ),
    ];

    switch (control.currentMode) {
      case CalendarMode.month:
        calendarWidgets.addAll(_monthViewBuilder());
        break;

      case CalendarMode.week:
        calendarWidgets.addAll(_weekViewBuilder());
        break;

      case CalendarMode.day:
        calendarWidgets.addAll(_dayViewBuilder());
        break;

      default:
    }

    calendarWidgets.add(_detailsViewBuilder());
    return Column(
      children: calendarWidgets,
    );
  }

  AnimatedSwitcher _switcherBuilder(Widget content) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween<Offset>(begin: Offset.zero, end: Offset(0, 0))
              .animate(animation),
          child: child,
        );
      },
      layoutBuilder: (currentChild, _) => currentChild,
      child: Dismissible(
        key: ValueKey(control.keyDate.millisecondsSinceEpoch),
        resizeDuration: null,
        onDismissed: _onHorizontalSwipe,
        direction: DismissDirection.horizontal,
        child: content,
      ),
    );
  }

  List<Widget> _monthViewBuilder() {
    return <Widget>[
      headerBuilder(),
      DaysRow(),
      Expanded(child: _switcherBuilder(monthBuilder(control.keyDate))),
    ];
  }

  AnimatedContainer _detailsViewBuilder() {
    return AnimatedContainer(
      height: detailsHeight,
      color: Colors.red,
      child: Center(
    child: Text('Details'),
      ),
      duration: Duration(milliseconds: 250),
    );
  }

  void _onCellTapped() {
    setState(() {
      detailsHeight = detailsHeight == 0 ? 200 : 0;
    });
    
  }

  List<Widget> _weekViewBuilder() {
    DateTime sunday = TickTock.sundayOfWeek(control.keyDate);
    return <Widget>[
      DaysRow(),
      // _switcherBuilder(
      //   _buildWeekRow(sunday)
      // )
    ];
  }

  List<Widget> _dayViewBuilder() {
    return <Widget>[
      _switcherBuilder(
        Container(
          height: 200,
          child: Center(
            child: Text('Day'),
          ),
        ),
      )
    ];
  }

  Container _modeBarBuilder() {
    return Container(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton(
            // shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
            child: Text('Month'),
            onPressed: () {
              _modeSelected(CalendarMode.month);
            },
          ),
          FlatButton(
            // shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
            child: Text(
              'Week',
            ),
            onPressed: () {
              _modeSelected(CalendarMode.week);
            },
          ),
          FlatButton(
            // shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
            child: Text('Day'),
            onPressed: () {
              _modeSelected(CalendarMode.day);
            },
          )
        ],
      ),
    );
  }

  Container monthBuilder(DateTime month) {
    return Container(
      color: Colors.red,
      // height: monthHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: buildMonth(month: month),
      ),
    );
  }

  List<Expanded> buildMonth({DateTime month}) {
    List<Expanded> weeks = [];

    int week = 0;
    while (week < 5) {
      DateTime firstSunday = TickTock.firstSunday(month);
      if (week == 0) {
        weeks.add(buildWeek(firstSunday));
      } else {
        DateTime sunday = firstSunday.add(Duration(days: 7 * week));
        weeks.add(buildWeek(sunday));
      }

      week++;
    }

    return weeks;
  }

  Expanded buildWeek(DateTime sunday) {
    List<DateTime> week = TickTock.daysOfWeek(sunday);

    List<Widget> days = [];
    for (var day in week) {
      bool hasSession = control.eventDates.indexOf(day) != -1;
      days.add(DayOfMonthCell(
        date: day,
        displayedMonth: control.keyDate.month,
        tapCallback: _onCellTapped,
        hasSession: hasSession,
      ));
    }

    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: days,
      ),
    );
  }

  Container headerBuilder() {
    return Container(
      color: Colors.green,
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              _onPeriodChange(-1);
            },
            child: Icon(Icons.chevron_left),
          ),
          Center(
            child: Text(
              monthString(control.keyDate.month) +
                  ' ' +
                  control.keyDate.year.toString(),
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          FlatButton(
            onPressed: () {
              _onPeriodChange(1);
            },
            child: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  /*  **********
        ******* ACTIONS **************
      **********
  */

  void _onPeriodChange(int change) {
    setState(() {
      control.changeTimeRange(change);
    });
  }

  void _onHorizontalSwipe(DismissDirection direction) {
    if (direction == DismissDirection.startToEnd) {
      _onPeriodChange(-1);

      // monthChangeCallback(-1);
    } else {
      _onPeriodChange(1);

      // monthChangeCallback(1);
    }
  }

  void _modeSelected(CalendarMode newMode) {
    setState(() {
      control.modeChanged(newMode);
    });
  }

  void dayTapped() {
    print('tapped');
  }

  void changeMonth(int change) {
    // setState(() {
    //   testCount += change;
    // });

    monthChangeCallback(change);
  }
}
