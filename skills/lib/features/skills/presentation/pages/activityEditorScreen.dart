import 'package:flutter/material.dart';
import 'package:skills/core/stringConstants.dart';
import 'package:skills/features/skills/presentation/widgets/notesFormField.dart';

class ActivityEditorScreen extends StatefulWidget {
  @override
  _ActivityEditorScreenState createState() => _ActivityEditorScreenState();
}

class _ActivityEditorScreenState extends State<ActivityEditorScreen> {
  TextEditingController _notesController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[NotesFormField(_notesController, NOTES)],
      ),
    );
  }
}


