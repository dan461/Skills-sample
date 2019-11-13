import 'package:flutter/material.dart';
import 'daysRow.dart';
import 'dayCell.dart';

class Calendar extends StatefulWidget {
//  int displayedMonth;
//  int displayedYear;
//  final DateTime displayDate;

  Calendar() {
//    this.displayedMonth = month;
//    this.displayedYear = year;
//    this.displayDate = date;
  }

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  double monthHeight;
  DateTime activeMonth = DateTime.now();

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

  Container monthBuilder() {
    return Container(
      height: monthHeight,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey[300]),
              right: BorderSide(width: 1.0, color: Colors.grey[300]))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: buildMonth(month: activeMonth.month, year: activeMonth.year),
      ),
    );
  }

  List<Row> buildMonth({int month, int year}) {
    // using 12 noon to avoid daylight savings issues
    DateTime firstOfMonth = DateTime(year, month, 1, 12);

    List<Row> weeks = [];

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

  Row buildWeek(DateTime sunday) {
    List<Widget> days = [];

    for (var i = 0; i < 7; i++) {
      // make day cell
      DateTime thisDay;
      if (i == 0) {
        thisDay = sunday;
      } else {
        thisDay = sunday.add(Duration(days: i));
      }

      days.add(DayCell(
          height: monthHeight / 5, date: thisDay, month: activeMonth.month));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: days,
    );
  }

  void dayTapped() {
    print('tapped');
  }

  void changeMonth(int change) {
    setState(() {
      activeMonth = DateTime(activeMonth.year, activeMonth.month + change);
    });
  }

  DayCell buildDayCell() {
    return DayCell(height: monthHeight / 5, date: DateTime.now());
  }

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
    monthHeight = MediaQuery.of(context).size.height / 2.5;
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
                return monthBuilder();
              },
              onPageChanged: (index) {
                changeMonth(1);
              },
            ),
          ),
        ],
      ),
    );
  }
}
