import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_event.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_state.dart';
import 'package:skills/features/skills/presentation/pages/skillEditorScreen.dart';
import 'package:skills/service_locator.dart';
import 'newSkillScreen.dart';

class SkillsScreen extends StatefulWidget {
  @override
  _SkillsScreenState createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  SkillsBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = locator<SkillsBloc>();
    bloc.add(GetAllSkillsEvent());
  }

  void addSkill() async {
    bool skillAdded = false;
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SkillEditorScreen();
    }));
    // if (result != null) {
    // var insert = locator.get<InsertNewSkill>();
    // await insert(InsertParams(skill: newSkill));
    bloc.add(GetAllSkillsEvent());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (_) => bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Your Skills')),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                addSkill();
              },
            )
          ],
        ),
        body: BlocBuilder<SkillsBloc, SkillsState>(
          builder: (context, state) {
            Widget body;
            if (state is InitialSkillsState) {
              body = Container(
                height: MediaQuery.of(context).size.height / 5,
                child: Center(
                  child: Text('Empty'),
                ),
              );
            } else if (state is AllSkillsLoading) {
              body = Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is AllSkillsLoaded) {
              body = Container(
                child: SkillsList(skills: state.skills),
              );
            } else {
              // TODO - not great, deal with error better
              body = Container(
                child: Center(
                  child: Text('All skills error'),
                ),
              );
            }
            return body;
          },
        ),
      ),
    );
  }
}

class SkillsList extends StatefulWidget {
  final List<Skill> skills;
  const SkillsList({
    Key key,
    this.skills,
  }) : super(key: key);

  @override
  _SkillsListState createState() => _SkillsListState();
}

class _SkillsListState extends State<SkillsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      margin: EdgeInsets.fromLTRB(4, 2, 4, 4),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return SkillCell(
                  skill: widget.skills[index],
                );
              },
              itemCount: widget.skills.length,
            ),
          ),
        ],
      ),
    );
  }
}

class SkillCell extends StatelessWidget {
  final Skill skill;
  SkillCell({this.skill});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      padding: EdgeInsets.all(4),
      height: 70,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      skill.name,
                      style: Theme.of(context).textTheme.title,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(skill.source,
                        style: Theme.of(context).textTheme.subtitle),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Goal: 4hrs.',
                        style: Theme.of(context).textTheme.subtitle)
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Text('Last Practiced',
                    style: Theme.of(context).textTheme.subtitle),
                Text('10/10/19', style: Theme.of(context).textTheme.subtitle)
              ],
            ),
          )
        ],
      ),
    );
  }
}
