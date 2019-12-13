import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_event.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_state.dart';
import 'package:skills/features/skills/presentation/widgets/calendar.dart';
import 'package:skills/features/skills/presentation/widgets/dayDetails.dart';
import 'package:skills/service_locator.dart';

class SchedulerScreen extends StatefulWidget {
  @override
  _SchedulerScreenState createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  List<Session> sessions;

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
            body = _noContentBuilder();
          } else if (state is DaySelectedState) {
            body = _contentBuilder(state.date, state.sessions);
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
            )),
        Expanded(
            flex: 1,
            child: Center(
              child: Text('No Selection'),
            )),
      ],
    );
  }

  Container _contentBuilder(DateTime date, List<Session> sessions) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Calendar(
                tapCallback: _dateSelected,
              )),
          Expanded(
            flex: 1,
            child: DayDetails(
              date: date,
              sessions: sessions,
            ),
          ),
        ],
      ),
    );
  }

  DayDetails _dayDetailsBuilder(DateTime date, List<Session> sessions) {
    return DayDetails(
      date: date,
      sessions: sessions,
    );
  }

  void _dateSelected(DateTime selectedDate) {
    _bloc.add(DaySelectedEvent(selectedDate));
  }
}
