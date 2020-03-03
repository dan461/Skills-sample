import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skills/core/tickTock.dart';
import 'package:skills/features/skills/domain/entities/session.dart';

typedef SessionFormOnCancelCallback();
typedef SessionFormOnCreateSessionCallback(Session session);
typedef SessionFormOnDeleteSessionCallback();
typedef SessionFormCompleteSessionCallback();
typedef SessionFormOnDoneEditingCallback(Map<String, dynamic> changeMap);

class SessionForm extends StatefulWidget {
  final Session session;
  final DateTime sessionDate;
  final SessionFormOnCancelCallback cancelCallback;
  final SessionFormOnDeleteSessionCallback onDeleteSessionCallback;
  final SessionFormOnCreateSessionCallback onCreateSessionCallback;
  final SessionFormCompleteSessionCallback completeSessionCallback;
  final SessionFormOnDoneEditingCallback onDoneEditingCallback;

  const SessionForm({
    Key key,
    this.session,
    this.sessionDate,
    this.cancelCallback,
    this.onDeleteSessionCallback,
    this.onCreateSessionCallback,
    this.completeSessionCallback,
    this.onDoneEditingCallback,
  }) : super(key: key);

  @override
  _SessionFormState createState() => _SessionFormState(
      session,
      sessionDate,
      cancelCallback,
      onCreateSessionCallback,
      onDoneEditingCallback,
      onDeleteSessionCallback,
      completeSessionCallback);
}

class _SessionFormState extends State<SessionForm> {
  final Session session;
  final DateTime sessionDate;
  final SessionFormOnCancelCallback cancelCallback;
  final SessionFormOnDeleteSessionCallback onDeleteSessionCallback;
  final SessionFormOnCreateSessionCallback onCreateSessionCallback;
  final SessionFormCompleteSessionCallback completeSessionCallback;
  final SessionFormOnDoneEditingCallback onDoneEditingCallback;

  _SessionFormState(
      this.session,
      this.sessionDate,
      this.cancelCallback,
      this.onCreateSessionCallback,
      this.onDoneEditingCallback,
      this.onDeleteSessionCallback,
      this.completeSessionCallback) {
    if (_isEditing) _selectedStartTime = session.startTime;
  }

  TextEditingController _nameController = TextEditingController();

  DateTime _selectedDate;
  TimeOfDay _selectedStartTime;

  bool _doneEnabled = true;

  bool get _isEditing {
    return session != null;
  }

  String get _selectedDateString {
    _selectedDate ??= sessionDate;
    return DateFormat.yMMMd().format(_selectedDate);
  }

  String get _startTimeString {
    return _selectedStartTime == null
        ? 'Select Time'
        : _selectedStartTime.format(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: SingleChildScrollView(
      child: Container(
        child: _sessionColumn(),
      ),
    ));
  }

  Widget _sessionColumn() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _nameField(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _dateRowBuilder(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _timeRow(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _durationRow(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _availableTimeRow(),
        ),
        _bottomButtons()
      ],
    );
  }

  TextFormField _nameField() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: _nameController,
      decoration: InputDecoration(labelText: 'Name (optiona)'),
    );
  }

  Row _dateRowBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Material(
            shape:
                Border(bottom: BorderSide(color: Colors.blue[100], width: 1.0)),
            child: InkWell(
              child: Text(
                _selectedDateString,
                style: Theme.of(context).textTheme.title,
              ),
              onTap: () {
                _pickNewDate();
              },
            ),
          ),
        ),
      ],
    );
  }

  Row _timeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 4),
            child: _timeSelectionBox(
                'Start: ', _startTimeString, _selectStartTime)),
      ],
    );
  }

  Row _durationRow() {
    return Row(
      children: <Widget>[Text('duration picker')],
    );
  }

  Row _availableTimeRow() {
    var timeString = 'session.availableTime';
    return Row(
      children: <Widget>[
        Text('Available: $timeString min.',
            style: Theme.of(context).textTheme.subhead)
      ],
    );
  }

  Container _timeSelectionBox(
      String descText, String timeText, Function callback) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(descText, style: Theme.of(context).textTheme.subhead),
          InkWell(
            child: Text(timeText, style: Theme.of(context).textTheme.subhead),
            onTap: () {
              callback();
              // _setDoneBtnStatus();
            },
          )
        ],
      ),
    );
  }

  Widget _durationSelector() {}

  ButtonBar _bottomButtons() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(onPressed: _onCancel, child: Text('Cancel')),
        FlatButton(onPressed: _onDelete, child: Text('Delete')),
        FlatButton(onPressed: _onComplete, child: Text('Complete')),
        FlatButton(
            onPressed: _doneEnabled ? _onDone : null, child: Text('Done')),
      ],
    );
  }

  // ****** ACTIONS ***********
  void _onCancel() async {
    if (_doneEnabled) {
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Discard changes?'),
              content: Text('Do you want to cancel and lose your changes?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Dismiss'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Continue'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    cancelCallback();
                  },
                )
              ],
            );
          });
    } else
      cancelCallback();
  }

  void _onDone() {
    if (_isEditing) {
      // get change map, call callback
      // onDoneEditingCallback()
    } else {
      // create new Session
    }
  }

  void _onDelete() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete this Session?'),
            content: Text('Are you sure you want to delete this session?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Dismiss'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Continue'),
                onPressed: () {
                  Navigator.of(context).pop();
                  onDeleteSessionCallback();
                },
              )
            ],
          );
        });
  }

  void _onComplete() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Complete this Session?'),
            content: Text('Do you want to mark this session as completed?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Dismiss'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Continue'),
                onPressed: () {
                  Navigator.of(context).pop();
                  completeSessionCallback();
                },
              )
            ],
          );
        });
  }

  void _pickNewDate() async {
    DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: sessionDate,
      firstDate: sessionDate.subtract(Duration(days: 365)),
      lastDate: sessionDate.add(
        Duration(days: 365),
      ),
    );

    if (pickedDate != null) {
      pickedDate.toUtc();
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _selectStartTime() async {
    TimeOfDay selectedTime = await showTimePicker(
        context: context,
        initialTime: _isEditing ? session.startTime : TimeOfDay.now());

    if (selectedTime != null) {
      // TODO - Time validation

      setState(() {
        // if (TickTock.timesAreEqual(selectedTime, bloc.selectedStartTime) ==
        //     false) {
        //   bloc.changeStartTime(selectedTime);
        // }
      });
    }

    // _setDoneBtnStatus();
  }
}
