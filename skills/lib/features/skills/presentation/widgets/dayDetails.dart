import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_bloc.dart';
import '../../presentation/widgets/sessionCard.dart';

class DayDetails extends StatefulWidget {
  final List<Map> sessions;
  final DateTime date;
  final Function newSessionCallback;
  final SchedulerBloc bloc;

  const DayDetails(
      {Key key,
      this.sessions,
      @required this.date,
      @required this.newSessionCallback,
      this.bloc})
      : super(key: key);
  @override
  _DayDetailsState createState() =>
      _DayDetailsState(sessions, newSessionCallback, bloc);
}

class _DayDetailsState extends State<DayDetails> {
  List<Map> sessions;
  bool hasSession = true;
  final Function newSessionCallback;
  final SchedulerBloc bloc;

  _DayDetailsState(this.sessions, this.newSessionCallback, this.bloc);

  @override
  void initState() {
    super.initState();
    // sessions = bloc.daysSessions;
  }

  // void _addSession() {

  // }

  Widget _showContentForSession() {
    if (sessions.isNotEmpty) {
      return new ListView.builder(
        itemBuilder: (context, index) {
          var sessionMap = sessions[index];
          return SessionCard(
            key: Key(sessionMap['session'].sessionId.toString()),
            sessionMap: sessionMap,
          );
        },
        itemCount: sessions.length,
      );
    } else {
      return Container(
        child: Center(
          child: RaisedButton(
            child: Text('Add a Session'),
            onPressed: () {
              newSessionCallback(widget.date);
            },
          ),
        ),
      );
    }
  }

  Container _headerBuilder() {
    String count = sessions.length.toString();
    return Container(
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              DateFormat.yMMMd().format(widget.date),
              style: Theme.of(context).textTheme.subhead,
            ),
            Text(
              '$count Sessions',
              style: Theme.of(context).textTheme.subhead,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO test only
    // hasSession = true;
    
    return Column(
      children: <Widget>[
        _headerBuilder(),
        Expanded(child: _showContentForSession())
      ],
    );
  }
}
