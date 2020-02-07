import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_bloc.dart';

import '../sessionCard.dart';

typedef ShowSessionEditorCallback(Session session);
typedef GoToNewSessionScreenCallback(DateTime date);

class DayDetails extends StatefulWidget {
  final List<Map> sessions;
  final DateTime date;
  final GoToNewSessionScreenCallback newSessionCallback;
  final ShowSessionEditorCallback editorCallback;
  final SchedulerBloc bloc;

  const DayDetails(
      {Key key,
      this.sessions,
      @required this.date,
      @required this.newSessionCallback,
      @required this.editorCallback,
      this.bloc})
      : super(key: key);
  @override
  _DayDetailsState createState() =>
      _DayDetailsState(sessions, newSessionCallback, editorCallback, bloc);
}

class _DayDetailsState extends State<DayDetails> {
  List<Map> sessions;
  bool hasSession = true;
  final GoToNewSessionScreenCallback newSessionCallback;
  final ShowSessionEditorCallback editorCallback;
  final SchedulerBloc bloc;

  _DayDetailsState(
      this.sessions, this.newSessionCallback, this.editorCallback, this.bloc);

  @override
  void initState() {
    super.initState();
  }

  Widget _showContentForSession() {
    if (sessions != null && sessions.isNotEmpty) {
      return new ListView.builder(
        itemBuilder: (context, index) {
          var sessionMap = sessions[index];
          return SessionCard(
            key: Key(sessionMap['session'].sessionId.toString()),
            sessionMap: sessionMap,
            editorCallback: editorCallback,
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
    String count = sessions != null ? sessions.length.toString(): "0";
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
    return Column(
      children: <Widget>[
        _headerBuilder(),
        Expanded(child: _showContentForSession())
      ],
    );
  }
}
