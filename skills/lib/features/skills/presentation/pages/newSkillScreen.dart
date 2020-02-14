import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/enums.dart';
import 'package:skills/core/tickTock.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/newSkillScreen/newskill_bloc.dart';
import 'package:skills/features/skills/presentation/pages/instrumentsScreen.dart';

class NewSkillScreen extends StatefulWidget {
  final NewskillBloc bloc;

  const NewSkillScreen({Key key, @required this.bloc}) : super(key: key);

  @override
  _NewSkillScreenState createState() => _NewSkillScreenState(bloc);
}

class _NewSkillScreenState extends State<NewSkillScreen> {
  final NewskillBloc bloc;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _sourceController = TextEditingController();

  SkillType _selectedType = SkillType.composition;
  String _selectedInstrument = SELECT_INST;
  String _profString = 'Rate 1 - 10';
  double currentProfValue = 0;
  String _priorityString = NORMAL_PRIORITY;

  final _formKey = GlobalKey<FormState>();

  _NewSkillScreenState(this.bloc);

  bool get _doneEnabled {
    return _nameController.text.isNotEmpty && _selectedInstrument != SELECT_INST;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (BuildContext context) => bloc,
        child: BlocListener<NewskillBloc, NewSkillState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is NewSkillInsertedState) {
              Navigator.of(context).pop();
            }
          },
          child: Builder(builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: Center(
                  child: Text('New Skill'),
                ),
              ),
              persistentFooterButtons: <Widget>[
                RaisedButton(
                    child: Text('Done!'),
                    onPressed: _doneEnabled
                        ? () {
                            _insertNewSkill();
                          }
                        : null),
              ],
              body: BlocBuilder<NewskillBloc, NewSkillState>(
                  builder: (context, state) {
                Widget body;
                if (state is InitialNewSkillState || state is NewSkillInsertedState) {
                  body = _newSkillFormBuilder(_formKey);
                } else if (state is CreatingNewSkillState) {
                  body = Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return body;
              }),
            );
          }),
        ));
  }

  Form _newSkillFormBuilder(Key formKey) {
    return Form(
      autovalidate: true,
      key: formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _typeButtons(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (_) {
                setDoneButtonEnabled();
              },
              validator: (value) {
                // _doneEnabled =
                //     value.isNotEmpty && _sourceController.text.isNotEmpty;
                if (value.isEmpty) {
                  // _doneEnabled = false;
                  return 'Name Required';
                } else
                  return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: _sourceController,
              decoration: InputDecoration(labelText: 'Source'),
              onChanged: (_) {
                setDoneButtonEnabled();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
            child: _instrumentPicker(),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: _proficiencyRow(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _priorityRow(),
          )
        ],
      ),
    );
  }

  Row _priorityRow() {
    return Row(
      children: <Widget>[
        Text('Priority: ', style: Theme.of(context).textTheme.subhead),
        DropdownButton<String>(
            value: _priorityString,
            items: PRIORITIES.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
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

  Row _proficiencyRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Proficiency: ',
              style: Theme.of(context).textTheme.subhead,
            ),
            Text(
              _profString,
              style: Theme.of(context).textTheme.subhead,
            ),
          ],
        ),
        Slider(
            min: 0,
            max: 10,
            value: currentProfValue,
            divisions: 10,
            onChanged: (newValue) {
              setState(() {
                currentProfValue = newValue;
                _profString = newValue.toString();
              });
            })
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
              value: SkillType.composition,
              groupValue: _selectedType,
              onChanged: (SkillType value) {
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
              value: SkillType.exercise,
              groupValue: _selectedType,
              onChanged: (SkillType value) {
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

  Row _instrumentPicker() {
    return Row(
      children: <Widget>[
        Text(
          'For: ',
          style: Theme.of(context).textTheme.subhead,
        ),
        GestureDetector(
          child: Text(
            _selectedInstrument,
            style: Theme.of(context).textTheme.subhead,
          ),
          onTap: _showInstrumentsList,
        )
      ],
    );
  }
// ACTIONS

  void _showInstrumentsList() async {
    String selected =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return InstrumentsScreen();
    }));

    setState(() {
      _selectedInstrument = selected ?? _selectedInstrument;
    });
  }

  void _doneTapped() {}

  void setDoneButtonEnabled() {}

  void _insertNewSkill() async {
    Skill newSkill = Skill(
      name: _nameController.text,
      type: skillTypeToString(_selectedType),
      source: _sourceController.text ?? '',
      startDate: TickTock.today(),
      instrument: _selectedInstrument,
      proficiency: currentProfValue.toInt(),
      priority: PRIORITIES.indexOf(_priorityString),
    );
    bloc.add(CreateNewSkillEvent(newSkill));
  }
}
