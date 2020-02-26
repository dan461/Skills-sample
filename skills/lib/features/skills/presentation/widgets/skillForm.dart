// import 'package:dartz/dartz_streaming.dart';
import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/enums.dart';
import 'package:skills/core/tickTock.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/helpers/skillChangeMonitor.dart';
import 'package:skills/features/skills/presentation/pages/instrumentsScreen.dart';

typedef SkillFormOnCancelCallback();
typedef SkillFormOnDoneCallback(Skill skill);

class SkillForm extends StatefulWidget {
  final Skill skill;
  final SkillFormOnCancelCallback cancelCallback;
  final SkillFormOnDoneCallback doneCallback;

  const SkillForm(
      {Key key,
      this.skill,
      @required this.cancelCallback,
      @required this.doneCallback})
      : super(key: key);
  @override
  _SkillFormState createState() =>
      _SkillFormState(skill, cancelCallback, doneCallback);
}



class _SkillFormState extends State<SkillForm> {
  final Skill skill;
  final SkillFormOnCancelCallback cancelCallback;
  final SkillFormOnDoneCallback doneCallback;

  _SkillFormState(this.skill, this.cancelCallback, this.doneCallback) {
    changes = SkillChangeMonitor(skill);
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _sourceController = TextEditingController();

  String _selectedType = skillTypeToString(SkillType.composition);
  String _selectedInstrument = SELECT_INST;
  String _profString = 'Rate 1 - 10';
  double currentProfValue = 0;
  String _priorityString = NORMAL_PRIORITY;
  SkillChangeMonitor changes;

  
  // bool get _doneEnabled {
  //   return _nameController.text.isNotEmpty &&
  //       _selectedInstrument != SELECT_INST;
  // }

  bool _doneEnabled = false;

  bool get _isEditing {
    return skill != null;
  }

  @override
  void initState() {
    if (_isEditing) {
      _nameController.text = skill.name;
      _nameController.addListener(_nameChangeListener);
      _sourceController.text = skill.source;
      _selectedType = skill.type;
      _selectedInstrument = skill.instrument;
      _profString = skill.proficiency.toString();
      currentProfValue = skill.proficiency.toDouble();
      _priorityString = PRIORITIES[skill.priority];
    }
    super.initState();
  }

  void _nameChangeListener() {
    changes.nameText = _nameController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: _newSkillColumn(),
        ),
      ),
    );
  }

  Widget _newSkillColumn() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: _typeButtons(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
          child: _nameField(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 20),
          child: _sourceField(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
          child: _instrumentPicker(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 38, 8, 8),
          child: _proficiencyRow(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _priorityRow(),
        ),
        _bottomButtons()
      ],
    );
  }

  ButtonBar _bottomButtons() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(onPressed: _onCancel, child: Text('Cancel')),
        FlatButton(
            onPressed: _doneEnabled ? _onDone : null, child: Text('Done')),
      ],
    );
  }

  Row _typeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Type:'),
            Radio(
              value: skillTypeToString(SkillType.composition),
              groupValue: _selectedType,
              onChanged: (String value) {
                setState(() {
                  _selectedType = value;
                });
              },
            ),
            Text('Compostion'),
          ],
        ),
        Row(
          children: <Widget>[
            Radio(
              value: skillTypeToString(SkillType.exercise),
              groupValue: _selectedType,
              onChanged: (String value) {
                setState(() {
                  _selectedType = value;
                });
              },
            ),
            Text('Exercise'),
          ],
        ),
      ],
    );
  }

  TextFormField _nameField() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: _nameController,
      decoration: InputDecoration(labelText: 'Name'),
      onChanged: (_) {
        setDoneButtonEnabled();
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Name Required';
        } else
          return null;
      },
    );
  }

  TextFormField _sourceField() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: _sourceController,
      decoration: InputDecoration(labelText: 'Source'),
    );
  }

  Row _instrumentPicker() {
    return Row(
      children: <Widget>[
        Material(
          color: Colors.transparent,
          shape:
              Border(bottom: BorderSide(width: 1.0, color: Colors.grey[400])),
          child: InkWell(
            child: Text(
              _selectedInstrument,
              style: Theme.of(context).textTheme.subhead,
            ),
            onTap: _showInstrumentsList,
          ),
        )
      ],
    );
  }

  Row _priorityRow() {
    return Row(
      children: <Widget>[
        Text('Priority: ', style: Theme.of(context).textTheme.body1),
        DropdownButton<String>(
            value: _priorityString,
            items: PRIORITIES.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: Theme.of(context).textTheme.body1),
              );
            }).toList(),
            onChanged: (String newValue) {
              setState(() {
                _priorityString = newValue;
              });
            })
      ],
    );
  }

  Column _proficiencyRow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Proficiency: ',
              style: Theme.of(context).textTheme.body1,
            ),
            Text(
              _profString,
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('0'),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Slider(
                  min: 0,
                  max: 10,
                  value: currentProfValue,
                  divisions: 10,
                  onChanged: (newValue) {
                    setState(() {
                      currentProfValue = newValue;
                      _profString = newValue.toInt().toString();
                    });
                  }),
            ),
            Text('10'),
          ],
        )
      ],
    );
  }

  // ACTIONS

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
    Skill newSkill;
    if (_isEditing) {
      newSkill = Skill(
        skillId: skill.skillId,
        name: _nameController.text,
        type: _selectedType,
        source: _sourceController.text ?? '',
        instrument: _selectedInstrument,
        startDate: skill.startDate ?? TickTock.today(),
        totalTime: skill.totalTime,
        lastPracDate: skill.lastPracDate,
        currentGoalId: skill.currentGoalId,
        // goalText: skill.goalText,
        priority: PRIORITIES.indexOf(_priorityString),
        proficiency: currentProfValue.toInt(),
      );
    } else {
      newSkill = Skill(
        name: _nameController.text,
        type: _selectedType,
        source: _sourceController.text ?? '',
        startDate: TickTock.today(),
        instrument: _selectedInstrument,
        priority: PRIORITIES.indexOf(_priorityString),
        proficiency: currentProfValue.toInt(),
      );
    }

    doneCallback(newSkill);
  }

  void _showInstrumentsList() async {
    String selected =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return InstrumentsScreen();
    }));

    setState(() {
      _selectedInstrument = selected ?? _selectedInstrument;
      setDoneButtonEnabled();
    });
  }

  void setDoneButtonEnabled() {
    setState(() {
      _doneEnabled =
          _nameController.text.isNotEmpty && _selectedInstrument != SELECT_INST;
    });
  }
}
