import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/newSkillScreen/newskill_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skillDataScreen/skilldata_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_event.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_state.dart';
import 'package:skills/features/skills/presentation/pages/skillDataScreen.dart';
import 'package:skills/features/skills/presentation/widgets/skillCell.dart';
import 'package:skills/service_locator.dart';

import 'newSkillScreen.dart';

typedef SelectionCallback(Skill skill);

class SkillsScreen extends StatefulWidget {
  final SelectionCallback callback;

  const SkillsScreen({Key key, this.callback}) : super(key: key);
  @override
  _SkillsScreenState createState() => _SkillsScreenState(callback);
}

class _SkillsScreenState extends State<SkillsScreen> {
  final SelectionCallback callback;
  SkillsBloc bloc;

  _SkillsScreenState(this.callback);
  @override
  void initState() {
    super.initState();
    bloc = locator<SkillsBloc>();
    bloc.add(GetAllSkillsEvent());
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (_) => bloc,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Your Skills'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.unfold_more),
                onPressed: () {
                  _ascDescTapped();
                }),
            _sortByBuilder(),
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
              // bloc.skills = state.skills;
              body = Container(
                color: Colors.white,
                child: SkillsList(
                  skills: bloc.skills,
                  callback: callback == null ? viewSkill : callback,
                ),
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

  // ****** BUILDERS *********
  Widget _sortByBuilder() {
    return PopupMenuButton<SkillSortOption>(
        tooltip: "Sort by...",
        icon: Icon(Icons.sort),
        onSelected: (SkillSortOption choice) {
          _sortTapped(choice);
        },
        itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<SkillSortOption>>[
              const PopupMenuItem<SkillSortOption>(
                value: SkillSortOption.name,
                child: Text('Name'),
              ),
              const PopupMenuItem<SkillSortOption>(
                value: SkillSortOption.source,
                child: Text('Source'),
              ),
              const PopupMenuItem<SkillSortOption>(
                value: SkillSortOption.lastPracDate,
                child: Text('Last Practiced'),
              ),
              const PopupMenuItem<SkillSortOption>(
                value: SkillSortOption.instrument,
                child: Text('Instrument'),
              ),
              const PopupMenuItem<SkillSortOption>(
                value: SkillSortOption.priority,
                child: Text('Priority'),
              ),
              const PopupMenuItem<SkillSortOption>(
                value: SkillSortOption.proficiency,
                child: Text('Proficiency'),
              )
            ]);
  }

  void _ascDescTapped() {
    setState(() {
      bloc.ascDescTapped();
    });
  }

  void _sortTapped(SkillSortOption choice) {
    setState(() {
      bloc.sortOptionPicked(choice);
    });
  }

  void addSkill() async {
    // final newSkillScreen = NewSkillScreen(bloc: locator<NewskillBloc>());

    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewSkillScreen(bloc: locator<NewskillBloc>());
    }));

    bloc.add(GetAllSkillsEvent());
  }

  void viewSkill(Skill skill) async {
    final skillScreen = SkillDataScreen(bloc: locator<SkillDataBloc>());
    skillScreen.bloc.skill = skill;
    skillScreen.bloc.goal = skill.goal;
    skillScreen.bloc.add(GetEventsForSkillEvent(skillId: skill.skillId));
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return skillScreen;
    }));

    bloc.add(GetAllSkillsEvent());
  }

  // void editSkill(Skill skill) async {
  //   final editor = SkillEditorScreen(
  //     skillEditorBloc: locator<SkillEditorBloc>(),
  //   );
  //   editor.skillEditorBloc.add(EditSkillEvent(skill));
  //   await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //     return editor;
  //   }));
  //   bloc.add(GetAllSkillsEvent());
  // }
}

class SkillsList extends StatefulWidget {
  final List<Skill> skills;
  final SelectionCallback callback;
  const SkillsList({
    Key key,
    @required this.skills,
    @required this.callback,
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
                  callback: widget.callback,
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
