import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/insertNewSkill.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/bloc.dart';
import 'package:skills/service_locator.dart';

class NewSkillScreen extends StatefulWidget {
  @override
  _NewSkillScreenState createState() => _NewSkillScreenState();
}

class _NewSkillScreenState extends State<NewSkillScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _sourceController = TextEditingController();
  bool _doneEnabled = false;

  void setDoneButtonEnabled() {
    setState(() {
      _doneEnabled =
          _nameController.text.isNotEmpty && _sourceController.text.isNotEmpty;
    });
  }

  void _insertNewSkill() {
    Skill newSkill =
        Skill(name: _nameController.text, source: _sourceController.text);
    Navigator.of(context).pop(newSkill);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('New Skill'),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 8.0),
                child: TextField(
                  onChanged: (_) {
                    setDoneButtonEnabled();
                  },
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 8.0),
                child: TextField(
                  onChanged: (_) {
                    setDoneButtonEnabled();
                  },
                  controller: _sourceController,
                  decoration: InputDecoration(labelText: 'Source'),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 8.0),
                child: RaisedButton(
                    child: Text('Done'),
                    onPressed: _doneEnabled
                        ? () {
                            _insertNewSkill();
                          }
                        : null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
