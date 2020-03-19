import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/activeSessionScreen/activesession_bloc.dart';

class ActiveSessionScreen extends StatefulWidget {
  final ActiveSessionBloc bloc;

  const ActiveSessionScreen({Key key, this.bloc}) : super(key: key);
  @override
  _ActiveSessionScreenState createState() => _ActiveSessionScreenState(bloc);
}

class _ActiveSessionScreenState extends State<ActiveSessionScreen> {
  final ActiveSessionBloc bloc;

  _ActiveSessionScreenState(this.bloc);
  @override
  Widget build(BuildContext context) {
    Widget body;
    return BlocProvider(
      builder: (context) => bloc,
      child: BlocListener<ActiveSessionBloc, ActiveSessionState>(
        bloc: bloc,
        listener: (context, state) {},
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(),
            body: BlocBuilder<ActiveSessionBloc, ActiveSessionState>(
                builder: (context, state) {
              if (state is ActiveSessionInitial) {
                body = Center(child: CircularProgressIndicator());
              }
              // Info loaded
              else if (state is ActiveSessionInfoLoadedState) {
                body = _chooseActivityViewBuilder(
                    state.duration, state.activityMaps);
              }

              return body;
            }),
          );
        }),
      ),
    );
  }

  Column _chooseActivityViewBuilder(int duration, List<Map> maps) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _durationRow(duration),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _chooseRow(),
        ),
      ],
    );
  }

  Row _durationRow(int duration) {
    String durationString = duration.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('$durationString min.', style: Theme.of(context).textTheme.title)
      ],
    );
  }

  Row _chooseRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Choose an Activity to start with',
            style: Theme.of(context).textTheme.title)
      ],
    );
  }
}
