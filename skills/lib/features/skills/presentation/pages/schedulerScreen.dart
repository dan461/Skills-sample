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
            _bloc.add(VisibleDateRangeChangeEvent(_bloc.calendarControl.dateRange));
          }

          // Day selectedState, may only be needed for month mode
          else if (state is DaySelectedState) {
            body = _contentBuilder(state.date, state.maps);
          } else if (state is SessionsForRangeReturnedState) {
            // _bloc.sessionsForMonth = state.sessionsList;
            body = _contentBuilder(null, null);
          } else if (state is NewCalendarModeState) {}

          return body;
        },
      ),
    );
  }

  // Container _contentByMode(CalendarMode mode){

  //   switch (mode) {
  //     case CalendarMode.month:

  //       break;
  //     default:
  //   }
  // }

  Container _contentBuilder(DateTime selectedDate, List<Map> sessionMaps) {
    final today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .toUtc();
    sessionMaps ??= List<Map>();
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
          // Expanded(
          //   flex: 1,
          //   child: DayDetails(
          //     key: UniqueKey(),
          //     bloc: _bloc,
          //     date: selectedDate != null ? selectedDate : today,
          //     sessions: sessionMaps,
          //     newSessionCallback: _showNewSessionScreen,
          //     editorCallback: _showSessionEditor,
          //   ),
          // ),
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
