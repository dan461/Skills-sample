import 'package:flutter/material.dart';
import 'package:skills/core/tickTock.dart';
import 'package:skills/features/skills/presentation/widgets/CalendarWidgets/calendarControl.dart';
import 'package:skills/features/skills/presentation/widgets/CalendarWidgets/dayCell.dart';
import 'package:skills/features/skills/presentation/widgets/CalendarWidgets/dayDetails.dart';
import 'dayOfWeekCell.dart';
import 'daysRow.dart';
import 'dayOfMonthCell.dart';

typedef CalendarCellTapCallback(DateTime date);
typedef DetailsViewCloseCallback();
typedef void EventTappedCallback(CalendarEvent event);
typedef void DetailsViewCallback(DateTime date);

abstract class CalendarEvent {
  final DateTime date;
  final TimeOfDay startTime;
  final int duration;
  Widget weekView;
  Widget dayView;

  CalendarEvent(this.date, this.startTime, this.duration);
}

abstract class WeekCalendarCell {
  DateTime date;
  List events;
  CalendarCellTapCallback tapCallback;
  bool isFocused;
}

class Calendar extends StatefulWidget {
  final Function tapCallback;

  final EventTappedCallback eventTapCallback;
  final DetailsViewCallback detailsViewCallback;
  final double detailsViewOpenHeight;
  final CalendarControl control;

  const Calendar(
      {Key key,
      @required this.tapCallback,
      @required this.control,
      @required this.detailsViewOpenHeight,
      this.eventTapCallback,
      this.detailsViewCallback})
      : super(key: key);

  @override
  _CalendarState createState() => _CalendarState(tapCallback, control,
      eventTapCallback, detailsViewCallback, detailsViewOpenHeight);
}

class _CalendarState extends State<Calendar> with TickerProviderStateMixin {
  double monthHeight;

  final CalendarControl control;
  final Function tapCallback;

  final EventTappedCallback eventTapCallback;
  final DetailsViewCallback detailsViewCallback;
  final double detailsViewOpenHeight;

  int pageId = 0;

  double detailsHeight = 0.0;

  _CalendarState(this.tapCallback, this.control, this.eventTapCallback,
      this.detailsViewCallback, this.detailsViewOpenHeight);

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

  bool get detailsViewIsOpen {
    return detailsHeight == detailsViewOpenHeight;
  }

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
        calendarWidgets.addAll(_monthModeBuilder());
        break;

      case CalendarMode.week:
        calendarWidgets.addAll(_weekModeBuilder());
        break;

      case CalendarMode.day:
        calendarWidgets.addAll(_dayModeBuilder());
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
        key: ObjectKey(DayOfWeekCell()),
        resizeDuration: null,
        onDismissed: _onHorizontalSwipe,
        direction: DismissDirection.horizontal,
        child: content,
      ),
    );
  }

  List<Widget> _monthModeBuilder() {
    return <Widget>[
      headerBuilder(),
      DaysRow(),
      Expanded(child: _switcherBuilder(monthTableBuilder(control.keyDate))),
    ];
  }

  List<Widget> _weekModeBuilder() {
    return <Widget>[
      headerBuilder(),
      Expanded(child: _switcherBuilder(_weekColumnBuilder())),
    ];
  }

  Widget _weekColumnBuilder() {
    DateTime sunday = TickTock.sundayOfWeek(control.keyDate);
    List<DateTime> week = TickTock.daysOfWeek(sunday);
    List<DayOfWeekCell> daysList = [];

    for (var day in week) {
      List<Widget> eventViews = [];

      for (var event in control.events) {
        if (event.date.isAtSameMomentAs(day) && event.weekView != null)
          eventViews.add(event.weekView);
      }

      daysList.add(DayOfWeekCell(
        date: day,
        isFocused: day.isAtSameMomentAs(control.focusDay),
        eventViews: eventViews,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: daysList,
    );
  }

  AnimatedContainer _detailsViewBuilder() {
    return AnimatedContainer(
      height: detailsHeight,
      color: Colors.green[100],
      child: detailsHeight == 0
          ? null
          : DayDetails(
              key: UniqueKey(),
              sessions: control.dataSource.sessionMaps,
              date: control.selectedDay,
              newSessionCallback: _detailsViewCallback,
              editorCallback: _onEventTapped,
              closeCallback: _closeDetailsView,
            ),
      duration: Duration(milliseconds: 250),
    );
  }

  List<Widget> _dayModeBuilder() {
    return <Widget>[
      Expanded(
        child: _switcherBuilder(
          DayCell(
            date: control.dateRange.first,
            events: control.events,
          ),
        ),
      )
    ];
  }

  void _detailsViewCallback(DateTime date) {
    detailsViewCallback(date);
  }

  void _onEventTapped(CalendarEvent event) {
    eventTapCallback(event);
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

  Container monthTableBuilder(DateTime month) {
    return Container(
      color: Colors.red,
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
        weeks.add(Expanded(child: buildWeekRow(firstSunday)));
      } else {
        DateTime sunday = firstSunday.add(Duration(days: 7 * week));
        weeks.add(Expanded(child: buildWeekRow(sunday)));
      }

      week++;
    }

    return weeks;
  }

  // Builds a row of DayOfMonthCells for the Month mode table
  Row buildWeekRow(DateTime sunday) {
    List<DateTime> week = TickTock.daysOfWeek(sunday);

    List<Widget> days = [];
    for (var day in week) {
      bool hasSession = control.eventDates.indexOf(day) != -1;
      days.add(DayOfMonthCell(
        date: day,
        displayedMonth: control.keyDate.month,
        tapCallback: _onCellTapped,
        hasSession: hasSession,
        isFocused: day.isAtSameMomentAs(control.focusDay),
      ));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: days,
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

  void _onCellTapped(DateTime date) {
    if (date.isAtSameMomentAs(control.selectedDay) && detailsViewIsOpen)
      _closeDetailsView();
    else {
      setState(() {
        control.daySelected(date);
        control.selectedDay = date;
        detailsHeight = 200;
      });
    }
  }

  void _closeDetailsView() {
    setState(() {
      detailsHeight = 0;
    });
  }

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
      _closeDetailsView();
      control.modeChanged(newMode);
    });
  }

  void dayTapped() {
    print('tapped');
  }
}
