import 'package:flutter/material.dart';

class CancelDoneButtonBar extends StatelessWidget {
  final Function onDone;
  final Function onCancel;
  final String cancelText;
  final String doneText;
  bool doneEnabled;

  CancelDoneButtonBar(
      {Key key,
      @required this.onDone,
      @required this.onCancel,
      @required this.doneEnabled,
      this.cancelText,
      this.doneText})
      : super(key: key);

  String get cancelString {
    return cancelText ?? 'Cancel';
  }

  String get doneString {
    return doneText ?? 'Done';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ButtonBar(
        buttonMinWidth: 100,
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
              onPressed: onCancel,
              child: Text(cancelString, style: TextStyle(fontSize: 20))),
          FlatButton(
              onPressed: doneEnabled ? onDone : null,
              child: Text(doneString, style: TextStyle(fontSize: 20))),
        ],
      ),
    );
  }
}
