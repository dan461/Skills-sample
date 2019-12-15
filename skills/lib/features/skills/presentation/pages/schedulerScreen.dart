import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_event.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_state.dart';
import 'package:skills/features/skills/presentation/widgets/calendar.dart';
import 'package:skills/features/skills/presentation/widgets/dayDetails.dart';
import 'package:skills/service_locator.dart';

import 'newSessionScreen.dart';

class SchedulerScreen extends StatefulWidget {
  @override
  _SchedulerScreenState createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  List<Session> sessionsForMonth;

  SchedulerBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = locator<SchedulerBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (BuildContext context) => _bloc,
      child: BlocBuilder<SchedulerBloc, SchedulerState>(
        builder: (context, state) {
          Widget body;
          if (state is InitialSchedulerState) {
            body = Center(
              child: CircularProgressIndicator(),
            );
            _bloc.add(MonthSelectedEvent(
                DateTime(DateTime.now().year, DateTime.now().month)));
          } else if (state is DaySelectedState) {
            body = _contentBuilder(state.date, state.sessions);
          } else if (state is GettingSessionForMonthState) {
            body = Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SessionsForMonthReturnedState) {
            body = _contentBuilder(null, null);
            sessionsForMonth = state.sessionsList;
          }
          return body;
        },
      ),
    );
  }

  Column _noContentBuilder() {
    return Column(
      children: <Widget>[
        Expanded(
            flex: 2,
            child: Calendar(
              tapCallback: _dateSelected,
              monthChangeCallback: _calendarMonthChanged,
            )),
        Expanded(
            flex: 1,
            child: Center(
              child: Text('No Selection'),
            )),
      ],
    );
  }

  Container _contentBuilder(DateTime selectedDate, List<Session> daysSessions) {
    final today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Calendar(
                tapCallback: _dateSelected,
                monthChangeCallback: _calendarMonthChanged,
                sessionDates: _bloc.sessionDates,
              )),
          Expanded(
            flex: 1,
            child: DayDetails(
              date: selectedDate != null ? selectedDate : today,
              sessions: daysSessions,
              newSessionCallback: _showNewSessionScreen,
            ),
          ),
        ],
      ),
    );
  }

  // DayDetails _dayDetailsBuilder(DateTime date, List<Session> sessions) {
  //   return DayDetails(
  //     date: date,
  //     sessions: sessions,
  //   );
  // }

  void _showNewSessionScreen(DateTime date) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewSessionScreen(
        date: date,
      );
    }));

    // _bloc
  }

  void _calendarMonthChanged(DateTime month) {
    _bloc.add(MonthSelectedEvent(month));
  }

  void _dateSelected(DateTime selectedDate) {
    _bloc.add(DaySelectedEvent(selectedDate));
  }
}
