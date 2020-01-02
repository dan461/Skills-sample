import 'package:flutter/material.dart';
import 'daysRow.dart';
import 'dayCell.dart';

class Calendar extends StatefulWidget {
  final Function tapCallback;
  final Function monthChangeCallback;
  final List<DateTime> eventDates;
  final DateTime activeMonth;
  

  const Calendar({
    Key key,
    this.activeMonth,
    @required this.tapCallback,
    @required this.monthChangeCallback,
    this.eventDates,
  }) : super(key: key);

  @override
  _CalendarState createState() =>
      _CalendarState(tapCallback, monthChangeCallback, activeMonth, eventDates);
}

class _CalendarState extends State<Calendar> {
  
  double monthHeight;
  final DateTime activeMonth;
  final List<DateTime> eventDates;
  // final SchedulerBloc bloc;

  final Function tapCallback;
  final Function monthChangeCallback;
 

  _CalendarState(this.tapCallback, this.monthChangeCallback, this.activeMonth, this.eventDates);

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

  Container monthBuilder(DateTime month) {
    return Container(
      height: monthHeight,
      // decoration: BoxDecoration(
      //     color: Colors.red,
      //     border: Border(
      //         bottom: BorderSide(width: 1.0, color: Colors.grey[300]),
      //         right: BorderSide(width: 1.0, color: Colors.grey[300]))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: buildMonth(month: activeMonth.month, year: activeMonth.year),
      ),
    );
  }

  List<Expanded> buildMonth({int month, int year}) {
    // using 12 noon to avoid daylight savings issues
    DateTime firstOfMonth = DateTime(year, month, 1, 12);

    List<Expanded> weeks = [];

    int week = 0;
    while (week < 5) {
      DateTime firstSunday = firstOfMonth.weekday == 7
          ? firstOfMonth
          : firstOfMonth.subtract(Duration(days: firstOfMonth.weekday));
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
    List<Widget> days = [];

    for (var i = 0; i < 7; i++) {
      // make day cell
      DateTime thisDay = sunday;

      if (i > 0) {
        thisDay = sunday.add(Duration(days: i));
      }
      // else {
      //   thisDay = sunday.add(Duration(days: i));
      // }
      bool hasSession = eventDates.indexOf(thisDay) != -1;
      days.add(DayCell(
        date: thisDay,
        displayedMonth: activeMonth.month,
        tapCallback: tapCallback,
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

  void dayTapped() {
    print('tapped');
  }

  void changeMonth(int change) {
    
    // setState(() {
    //   _activeMonth = DateTime(_activeMonth.year, _activeMonth.month + change);
    // });
    monthChangeCallback(change);
  }

  // DayCell buildDayCell() {
  //   return DayCell(date: DateTime.now(), tapCallback: tapCallback);
  // }

  Container headerBuilder() {
    return Container(
      margin: EdgeInsets.all(4),
      child: Row(
        children: <Widget>[
          FlatButton(
            onPressed: () {
              changeMonth(-1);
            },
            child: Icon(Icons.chevron_left),
          ),
          Center(
            child: Text(
              monthString(activeMonth.month) +
                  ' ' +
                  activeMonth.year.toString(),
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          ),
          FlatButton(
            onPressed: () {
              changeMonth(1);
            },
            child: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    monthHeight = MediaQuery.of(context).size.height / 2.25;
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          headerBuilder(),
          DaysRow(),
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemBuilder: (context, position) {
                return monthBuilder(activeMonth);
              },
              onPageChanged: (index) {
                // changeMonth(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
