import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/presentation/bloc/new_session/new_session_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_event.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_state.dart';
import 'package:skills/features/skills/presentation/bloc/sessionDataScreen/sessiondata_bloc.dart';
import 'package:skills/features/skills/presentation/pages/liveSessionScreen.dart';
import 'package:skills/features/skills/presentation/pages/newSessionScreen.dart';
import 'package:skills/features/skills/presentation/pages/sessionDataScreen.dart';
import 'package:skills/features/skills/presentation/widgets/CalendarWidgets/calendar.dart';
import 'package:skills/service_locator.dart';

class SchedulerScreen extends StatefulWidget {
  @override
  _SchedulerScreenState createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
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
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            // title: Text('Your Skills'),
            backgroundColor: Theme.of(context).primaryColor,
            leading: IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                })),
        body: BlocBuilder<SchedulerBloc, SchedulerState>(
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
              body = Calendar(
                control: _bloc.calendarControl,
                tapCallback: _dateSelected,
                eventTapCallback: _showSessionEditor,
                detailsViewCallback: _showNewSessionScreen,
                detailsViewOpenHeight: 200,
              );
            } else if (state is SessionsForRangeReturnedState) {
              body = Calendar(
                control: _bloc.calendarControl,
                tapCallback: _dateSelected,
                detailsViewCallback: _showNewSessionScreen,
                eventTapCallback: _showSessionEditor,
                detailsViewOpenHeight: 200,
              );
            } else if (state is NewCalendarModeState) {}

            return Container(
              child: Column(
                children: <Widget>[
                  Expanded(flex: 2, child: body),
                  Row(
                    children: <Widget>[
                      FlatButton(
                          onPressed: _showLiveSessionScreen,
                          child: Text('Start Live Session'))
                    ],
                  )
                ],
              ),
            );
          },
        ),
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

    _bloc.add(VisibleDateRangeChangeEvent(_bloc.calendarControl.dateRange));
  }

  void _showSessionEditor(CalendarEvent session) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      SessionDataScreen dataScreen = locator<SessionDataScreen>();
      Session ses = session;
      dataScreen.bloc
          .add(GetSessionAndActivitiesEvent(sessionId: ses.sessionId));
      return dataScreen;
    }));
    _bloc.add(VisibleDateRangeChangeEvent(_bloc.calendarControl.dateRange));
  }

  void _showLiveSessionScreen() async {
    bool refresh =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LiveSessionScreen();
    }));
  }

  void _dateSelected(DateTime selectedDate) {
    setState(() {
      _bloc.add(DaySelectedEvent(selectedDate));
    });
  }
}
