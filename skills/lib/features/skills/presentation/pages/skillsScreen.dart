import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/getAllSkills.dart';
import 'package:skills/features/skills/domain/usecases/insertNewSkill.dart';
import 'package:skills/features/skills/presentation/bloc/newSkillScreen/bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_event.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_state.dart';
import 'package:skills/service_locator.dart';


class SkillsScreen extends StatefulWidget {
  @override
  _SkillsScreenState createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  
  void addSkill() {
     final testSkill = Skill(name: 'test', source: 'test');
          var insert = locator.get<InsertNewSkill>();
          insert(InsertParams(skill: testSkill));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          addSkill();
        },
      ),
      body: BlocProvider(
        builder: (_) => locator<SkillsBloc>(),
          child: BlocBuilder<SkillsBloc, SkillsState>(
            builder: (context, state){
              BlocProvider.of<SkillsBloc>(context).add(GetAllSkillsEvent());
              if (state is InitialSkillsState) {
                return Container(
                  height: MediaQuery.of(context).size.height / 5,
                  child: Center(
                    child: Text('Empty'),
                  ),
                );
              } else if (state is AllSkillsLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is AllSkillsLoaded) {
                return Container(child: SkillsList(skills: state.skills,));
              }
            },
          )
      ),
    );
  }
}

class SkillsList extends StatefulWidget {
  final List<Skill> skills;
  const SkillsList({
    Key key, this.skills,
  }) : super(key: key);

  @override
  _SkillsListState createState() => _SkillsListState();
}

class _SkillsListState extends State<SkillsList> {
  // static DbHelper helper = DbHelper.instance;

  
  @override
  void initState() {
    super.initState();
  }

  SkillCell _skillsListBuilder(BuildContext context, int index) {
    return SkillCell();
  }

  // static Skill testSkill(String name, String source) {
  //   Skill skill = Skill();
  //   skill.name = name;
  //   skill.source = source;
  //   return skill;
  // }

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
