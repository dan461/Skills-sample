import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_bloc.dart';
import 'package:skills/features/skills/presentation/widgets/calendar.dart';
import 'package:skills/features/skills/presentation/widgets/dayDetails.dart';
import 'package:skills/service_locator.dart';

class SchedulerScreen extends StatefulWidget {
  @override
  _SchedulerScreenState createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  List<Session> sessions;
  DayDetails _dayDetails;
  SchedulerBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = locator<SchedulerBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => _bloc,
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Calendar(
                tapCallback: _dateSelected,
              )),
          // Day Detail
          Expanded(flex: 1, child: _dayDetailsBuilder()),
        ],
      ),
    );
  }

  DayDetails _dayDetailsBuilder() {
    return DayDetails(
      sessions: _bloc.sessions,
    );
  }

  void _dateSelected(DateTime selectedDate) {
    setState(() {
      _bloc.sessions = [];
    });
  }
}
