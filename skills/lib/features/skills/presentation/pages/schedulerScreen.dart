import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  DateTime _activeMonth;

  SchedulerBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = locator<SchedulerBloc>();
    _activeMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _bloc.add(MonthSelectedEvent(_activeMonth));
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
          } else if (state is DaySelectedState) {
            body = _contentBuilder(state.date, _activeMonth);
          } else if (state is SessionsForMonthReturnedState) {
            _bloc.sessionsForMonth = state.sessionsList;
            body = _contentBuilder(null, _activeMonth);
          }

          return body;
        },
      ),
    );
  }

  Container _contentBuilder(DateTime selectedDate, DateTime month) {
    final today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Calendar(
                bloc: _bloc,
                tapCallback: _dateSelected,
                monthChangeCallback: _calendarMonthChanged,
                
              )),
          Expanded(
            flex: 1,
            child: DayDetails(
              bloc: _bloc,
              date: selectedDate != null ? selectedDate : today,
              sessions: _bloc.daysSessions,
              newSessionCallback: _showNewSessionScreen,
            ),
          ),
        ],
      ),
    );
  }

  void _showNewSessionScreen(DateTime date) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewSessionScreen(
        date: date,
      );
    }));

    _bloc.add(MonthSelectedEvent(_bloc.activeMonth));
  }

  void _calendarMonthChanged(int change) {
    setState(() {
      _bloc.activeMonth =
          DateTime(_bloc.activeMonth.year, _bloc.activeMonth.month + change);
    });
    
    _bloc.add(MonthSelectedEvent(_bloc.activeMonth));
  }

  void _dateSelected(DateTime selectedDate) {
    setState(() {
      _bloc.add(DaySelectedEvent(selectedDate));
    });
  }
}
