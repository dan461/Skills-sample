import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/presentation/bloc/new_session/bloc.dart';
import 'package:skills/features/skills/presentation/widgets/sessionForm.dart';

class NewSessionScreen extends StatefulWidget {
  final DateTime date;
  final NewSessionBloc bloc;

  const NewSessionScreen({Key key, @required this.date, @required this.bloc})
      : super(key: key);
  @override
  _NewSessionScreenState createState() => _NewSessionScreenState(date, bloc);
}

class _NewSessionScreenState extends State<NewSessionScreen> {
  final DateTime date;
  final NewSessionBloc bloc;

  _NewSessionScreenState(this.date, this.bloc);

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  Map<String, dynamic> currentEventMap = {};

  @override
  void initState() {
    super.initState();

    bloc.sessionDate ??= date;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => bloc,
      child: BlocListener<NewSessionBloc, NewSessionState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is NewSessionInsertedState) {
            Navigator.of(context).popAndPushNamed(SESSION_DATA_ROUTE,
                arguments: state.newSession);
          }
        },
        child: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: Text('New Session'),
                leading: SizedBox(),
              ),
              body: BlocBuilder<NewSessionBloc, NewSessionState>(
                builder: (context, state) {
                  Widget body;
                  if (state is InitialNewSessionState) {
                    body = _contentBuilder();
                  } else if (state is NewSessionCrudInProgressState) {
                    body = Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is NewSessionInsertedState) {
                    body = Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return body;
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Container _contentBuilder() {
    return Container(
      child: Column(
        children: <Widget>[
          SessionForm(
            sessionDate: date,
            cancelCallback: _onCancelTapped,
            onCreateSessionCallback: _onDoneTapped,
          )
        ],
      ),
    );
  }

  void _onDoneTapped(Session newSession) {
    bloc.add(InsertNewSessionEvent(newSession: newSession));
  }

  void _onCancelTapped() {
    Navigator.of(context).pop();
  }
}
