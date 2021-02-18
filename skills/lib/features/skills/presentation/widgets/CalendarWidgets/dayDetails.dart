import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/presentation/bloc/schedulerScreen/scheduler_bloc.dart';

import '../sessionCard.dart';
import 'calendar.dart';

typedef ShowSessionEditorCallback(Session session);
typedef GoToNewSessionScreenCallback(DateTime date);

class DayDetails extends StatefulWidget {
  final List<Map> sessions;
  final DateTime date;
  final DetailsViewCallback newSessionCallback;
  final EventTappedCallback editorCallback;
  final DetailsViewCloseCallback closeCallback;
  final SchedulerBloc bloc;

  const DayDetails(
      {Key key,
      this.sessions,
      @required this.date,
      @required this.newSessionCallback,
      @required this.editorCallback,
      @required this.closeCallback,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _headerBuilder(context),
        Expanded(child: _showContentForSession())
      ],
    );
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
        color: Theme.of(context).colorScheme.background,
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

  Container _headerBuilder(BuildContext context) {
    String count = sessions != null ? sessions.length.toString() : "0";
    return Container(
      height: 35,
      color: Theme.of(context).colorScheme.primaryVariant,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _close,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                DateFormat.yMMMd().format(widget.date),
                style: TextStyle(color: Colors.white),
              ),
              Text(
                '$count Sessions',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _close() {
    widget.closeCallback();
  }
}
