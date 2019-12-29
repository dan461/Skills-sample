import 'package:flutter/material.dart';

class SessionScreen extends StatefulWidget {
final DateTime date;

  const SessionScreen({Key key, this.date}) : super(key: key);

  @override
  _SessionScreenState createState() => _SessionScreenState(date);
}

class _SessionScreenState extends State<SessionScreen> {
final DateTime date;

  _SessionScreenState(this.date);


  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}