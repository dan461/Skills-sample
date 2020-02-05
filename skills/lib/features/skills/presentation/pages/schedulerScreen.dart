import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/usecases/sessionUseCases.dart';
import 'package:skills/features/skills/presentation/bloc/new_session/new_session_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/new_session/new_session_event.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_event.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_state.dart';
import 'package:skills/features/skills/presentation/bloc/sessionEditorScreen/bloc.dart';
import 'package:skills/features/skills/presentation/pages/sessionEditorScreen.dart';
import 'package:skills/features/skills/presentation/widgets/CalendarWidgets/calendar.dart';
import 'package:skills/features/skills/presentation/widgets/CalendarWidgets/calendarControl.dart';
import 'package:skills/features/skills/presentation/widgets/CalendarWidgets/dayDetails.dart';
import 'package:skills/service_locator.dart';

import 'newSessionScreen.dart';

class SchedulerScreen extends StatefulWidget {
  @override
  _SchedulerScreenState createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  // DateTime _activeMonth;

  SchedulerBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = locator<SchedulerBloc>();

    _bloc.add(MonthSelectedEvent(change: 0));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (BuildContext context) => _bloc,
      child: BlocBuilder<SchedulerBloc, SchedulerState>(
        builder: (context, state) {
          Widget body;
          if (state is InitialSchedulerState ||
              state is GettingSessionsForDateRangeState) {
            body = Center(
              child: CircularProgressIndicator(),
            );
            _bloc.add(
                VisibleDateRangeChangeEvent(_bloc.calendarControl.dateRange));
          }

          // Day selectedState, may only be needed for month mode
          else if (state is DaySelectedState) {
            body = _contentBuilder(state.date, state.maps);
          } 
          
          else if (state is SessionsForRangeReturnedState) {
            // _bloc.sessionsForMonth = state.sessionsList;
            body = Calendar(
              control: _bloc.calendarControl,
              tapCallback: _dateSelected,
              monthChangeCallback: _calendarMonthChanged,
            );
          } 
          
          else if (state is NewCalendarModeState) {}

          return Container(
            child: Column(
              children: <Widget>[
                Expanded(flex: 2, child: body),
              ],
            ),
          );
        },
      ),
    );
  }

  Container _contentBuilder(DateTime selectedDate, List<Map> sessionMaps) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Calendar(
                control: _bloc.calendarControl,
                tapCallback: _dateSelected,
                monthChangeCallback: _calendarMonthChanged,
              )),
        ],
      ),
    );
  }

  void _showNewSessionScreen(DateTime date) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewSessionScreen(
        date: date,
        bloc: locator<NewSessionBloc>(),
      );
    }));

    _bloc.add(MonthSelectedEvent(change: 0));
  }

  void _showSessionEditor(Session session) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      SessionEditorScreen editor = SessionEditorScreen(
        bloc: locator<SessionEditorBloc>(),
        session: session,
      );

      return editor;
    }));
    // await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    //   NewSessionScreen editor = NewSessionScreen(
    //     date: session.date,
    //     bloc: locator<NewSessionBloc>(),
    //   );
    //   editor.bloc.add(BeginSessionEditingEvent(session: session));
    //   return editor;
    // }));

    _bloc.add(MonthSelectedEvent(change: 0));
  }

  void _calendarMonthChanged(int change) {
    setState(() {
      // var newMonth = DateTime(_bloc.activeMonth.year, _bloc.activeMonth.month + change);
      // _bloc.activeMonth = null;
      // _bloc.activeMonth = newMonth;
      _bloc.add(MonthSelectedEvent(change: change));
    });
  }

  void _dateSelected(DateTime selectedDate) {
    setState(() {
      _bloc.add(DaySelectedEvent(selectedDate));
    });
  }
}
