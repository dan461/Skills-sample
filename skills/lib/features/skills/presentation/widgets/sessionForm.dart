import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skills/core/textStyles.dart';
import 'package:skills/core/tickTock.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/presentation/helpers/sessionChangeMonitor.dart';

typedef SessionFormOnCancelCallback();
typedef SessionFormOnCreateSessionCallback(Session session);
typedef SessionFormOnDeleteSessionCallback();
typedef SessionFormOnDoneEditingCallback(Map<String, dynamic> changeMap);

class SessionForm extends StatefulWidget {
  final Session session;
  final DateTime sessionDate;
  final SessionFormOnCancelCallback cancelCallback;
  final SessionFormOnDeleteSessionCallback onDeleteSessionCallback;
  final SessionFormOnCreateSessionCallback onCreateSessionCallback;
  final SessionFormOnDoneEditingCallback onDoneEditingCallback;

  const SessionForm({
    Key key,
    this.session,
    this.sessionDate,
    this.cancelCallback,
    this.onDeleteSessionCallback,
    this.onCreateSessionCallback,
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
      );
}

class _SessionFormState extends State<SessionForm> {
  final Session session;
  final DateTime sessionDate;
  final SessionFormOnCancelCallback cancelCallback;
  final SessionFormOnDeleteSessionCallback onDeleteSessionCallback;
  final SessionFormOnCreateSessionCallback onCreateSessionCallback;
  final SessionFormOnDoneEditingCallback onDoneEditingCallback;

  _SessionFormState(
    this.session,
    this.sessionDate,
    this.cancelCallback,
    this.onCreateSessionCallback,
    this.onDoneEditingCallback,
    this.onDeleteSessionCallback,
  ) {
    if (_isEditing) _selectedStartTime = session.startTime;
    changeMonitor = SessionChangeMonitor(session);
  }

  TextEditingController _nameController = TextEditingController();

  DateTime _selectedDate;
  TimeOfDay _selectedStartTime;
  Duration selectedDuration;
  SessionChangeMonitor changeMonitor;

  bool _doneEnabled = false;

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

  String get _durationString {
    var durationIntString = selectedDuration.inMinutes.toString();
    return '$durationIntString min.';
  }

  int get _tentativeOpenTime {
    if (selectedDuration.inMinutes < session.duration)
      return session.openTime - (session.duration - selectedDuration.inMinutes);
      else 
      return session.openTime + (selectedDuration.inMinutes - session.duration);
  }

  int get _scheduledMinutes {
    return session.duration - session.openTime;
  }

  @override
  void initState() {
    selectedDuration =
        _isEditing ? Duration(minutes: session.duration) : Duration(minutes: 5);
    _nameController.addListener(_nameChangeListener);

    super.initState();
  }

  // CHANGE LISTENERS
  void _nameChangeListener() {
    if (_isEditing) changeMonitor.nameText = _nameController.text;
    setDoneButtonEnabled();
  }

  void _dateChanged(DateTime newDate) {
    _selectedDate = newDate;
    if (_isEditing) changeMonitor.date = newDate;
    setDoneButtonEnabled();
  }

  void _startTimeChanged(TimeOfDay newStart) {
    _selectedStartTime = newStart;
    if (_isEditing) changeMonitor.startTime = newStart;
    setDoneButtonEnabled();
  }

  void _durationChanged(Duration newDuration) {
    if (newDuration.inMinutes < 5) {
      selectedDuration = Duration(minutes: 5);
      _showIncorrectDurationWarning(true);
    } else if (_isEditing &&
        newDuration.inMinutes < (session.duration - session.openTime)) {
      _showIncorrectDurationWarning(false);
      selectedDuration = Duration(minutes: session.duration);
    } else
      selectedDuration = newDuration;

    if (_isEditing) changeMonitor.duration = newDuration.inMinutes;
    setDoneButtonEnabled();
  }

  void _showIncorrectDurationWarning(bool underFive) async {
    String message;
    if (underFive) {
      message = 'The Session minimum is 5 minutes';
    } else
      message =
          'Your Session needs to be at least as long as the activities scheduled in it.';

    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Insufficient Duration'),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('Got it'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showDurationPicker();
                },
              ),
            ],
          );
        });
  }

  void _completedStatusChanged(bool completed) {
    // TODO - this can only change from false to true, can't 'de-complete' a Session yet, callback probably not needed
    setState(() {
      changeMonitor.isComplete = completed;
    });

    setDoneButtonEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: _sessionColumn(),
        ),
      ),
    ));
  }

  Widget _sessionColumn() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: _nameField(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: _dateRowBuilder(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: _timeRow(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: _durationRow(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: _availableTimeRow(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _bottomButtons(),
        )
      ],
    );
  }

  TextFormField _nameField() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: _nameController,
      decoration: InputDecoration(labelText: 'Name (optional)'),
    );
  }

  Row _dateRowBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Material(
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
        _statusBox()
      ],
    );
  }

  Widget _statusBox() {
    Widget box = SizedBox();
    if (_isEditing) {
      if (session.isComplete || changeMonitor.isComplete) {
        box = Text(
          "Completed",
          style: TextStyle(color: Colors.green, fontSize: 18),
        );
      } else {
        box = Material(
          shape:
              Border(bottom: BorderSide(color: Colors.blue[100], width: 1.0)),
          child: InkWell(
            child: Text(
              "Scheduled",
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            onTap: () {
              _onComplete();
            },
          ),
        );
      }
    }
    return box;
  }

  Row _timeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _timeSelectionBox('Start: ', _startTimeString, _selectStartTime),
      ],
    );
  }

  Row _durationRow() {
    // var durationString = session.duration.toString();
    return Row(
      children: <Widget>[
        Text(
          'Duration: ',
          style: Theme.of(context).textTheme.subhead,
        ),
        Material(
          color: Colors.transparent,
          shape:
              Border(bottom: BorderSide(width: 1.0, color: Colors.grey[400])),
          child: InkWell(
            child: Text(
              _durationString,
              style: Theme.of(context).textTheme.subhead,
            ),
            onTap: _showDurationPicker,
          ),
        )
      ],
    );
  }

  Widget _durationPicker() {
    return CupertinoTimerPicker(
      initialTimerDuration: _isEditing
          ? selectedDuration
          : Duration(minutes: 5),
      onTimerDurationChanged: _onDurationChange,
      mode: CupertinoTimerPickerMode.hm,
      minuteInterval: 5,
    );
  }

  Row _availableTimeRow() {
    var openTimeString = _tentativeOpenTime.toString();
    var scheduledTimeString = _scheduledMinutes.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Available: $openTimeString min.', style: TextStyles.subheadDisabled),
        Text('$scheduledTimeString min. of Activities scheduled', style: TextStyles.subheadDisabled)
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
          Material(
            color: Colors.transparent,
            shape:
                Border(bottom: BorderSide(width: 1.0, color: Colors.grey[400])),
            child: InkWell(
              child: Text(timeText, style: Theme.of(context).textTheme.subhead),
              onTap: () {
                callback();
                // _setDoneBtnStatus();
              },
            ),
          )
        ],
      ),
    );
  }

  ButtonBar _bottomButtons() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(onPressed: _onCancel, child: Text('Cancel')),
        FlatButton(onPressed: _onDelete, child: Text('Delete'), textColor: Colors.red),
        FlatButton(
            onPressed: _doneEnabled ? _onDone : null, child: Text('Done')),
      ],
    );
  }

  // ****** ACTIONS ***********

  void _showDurationPicker() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(height: 150, child: _durationPicker()),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Set'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _durationChanged(selectedDuration);
                },
              ),
            ],
          );
        });
  }

  void _onDurationChange(Duration duration) {
    selectedDuration = duration;
  }

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
                  child: Text('No'),
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
      onDoneEditingCallback(changeMonitor.toMap());
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
                  _completedStatusChanged(true);
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
      pickedDate = pickedDate.toUtc();
      setState(() {
        _dateChanged(pickedDate);
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
        _startTimeChanged(selectedTime);
      });
    }

    // _setDoneBtnStatus();
  }

  void setDoneButtonEnabled() {
    setState(() {
      if (_isEditing) {
        _doneEnabled = changeMonitor.hasChanged;
      } else
        _doneEnabled = _nameController.text.isNotEmpty && _selectedDate != null;
    });
  }
}
