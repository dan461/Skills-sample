import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/newSkillScreen/newskill_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skillsDetailScreen/skilldata_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_event.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_state.dart';
import 'package:skills/features/skills/presentation/pages/skillListWidget.dart';
import 'package:skills/features/skills/presentation/pages/skillsDetailScreen.dart';
import 'package:skills/features/skills/presentation/widgets/skillCell.dart';
import 'package:skills/service_locator.dart';
import 'package:skills/features/skills/presentation/pages/baseScreen.dart';

import 'newSkillScreen.dart';

typedef SelectionCallback(Skill skill);

class SkillsMasterScreen extends StatefulWidget {
  final SelectionCallback callback;

  const SkillsMasterScreen({Key key, this.callback}) : super(key: key);
  @override
  _SkillsMasterScreenState createState() => _SkillsMasterScreenState(callback);
}

class _SkillsMasterScreenState extends State<SkillsMasterScreen> {
  final SelectionCallback callback;
  SkillsBloc bloc;
  SkillDataBloc detailsBloc;

  Skill _selectedSkill;

  bool _showSkillDetails = false;
  _SkillsMasterScreenState(this.callback);

  int _sideBySideBreakpoint = 600;
  bool get showSideBySide {
    return MediaQuery.of(context).size.width > _sideBySideBreakpoint;
  }

  @override
  void initState() {
    super.initState();
    bloc = locator<SkillsBloc>();
    bloc.add(GetAllSkillsEvent());
    detailsBloc = locator<SkillDataBloc>();
    // _showSkillDetails = false;
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
        floatingActionButtonLocation: showSideBySide
            ? FloatingActionButtonLocation.startFloat
            : FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).backgroundColor,
          tooltip: ADD_SKILL_TOOLTIP,
          child: Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: addSkill,
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Your Skills'),
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              }),
          actions: <Widget>[
            IconButton(
                tooltip: ASCDESC_TOOLTIP,
                icon: Icon(Icons.unfold_more),
                onPressed: () {
                  _ascDescTapped();
                }),
            _sortByBuilder(),
            IconButton(
              tooltip: DETAILS_TOOLTIP,
              icon: Icon(Icons.details),
              onPressed: () {
                setState(() {
                  _showSkillDetails = !_showSkillDetails;
                });
              },
            )
          ],
        ),
        body: BlocBuilder<SkillsBloc, SkillsState>(
          builder: (context, state) {
            return LayoutBuilder(
              builder: (builder, constraints) {
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
                  body = _masterView();
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
            );
          },
        ),
      ),
    );
  }

  Widget _masterView() {
    _selectedSkill = _selectedSkill == null ? bloc.skills[0] : _selectedSkill;

    Expanded listView = Expanded(
      child: Container(
        // width: 500,
        color: Theme.of(context).colorScheme.primaryVariant,
        child: SkillsList(
          skills: bloc.skills,
          callback: callback == null ? viewSkill : callback,
          showDetails: _showSkillDetails,
        ),
      ),
    );
    if (showSideBySide) {
      return Row(
        children: [
          listView,
          VerticalDivider(
            color: Colors.black38,
            width: 1,
          ),
          Expanded(
            child: _skillDetailsScreen(),
          )
        ],
      );
    } else {
      return Row(
        children: [listView],
      );
    }
  }

  // ****** BUILDERS *********
  Widget _sortByBuilder() {
    return PopupMenuButton<SkillSortOption>(
        tooltip: SORT_TOOLTIP,
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
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewSkillScreen(bloc: locator<NewskillBloc>());
    }));

    bloc.add(GetAllSkillsEvent());
  }

  Widget _skillDetailsScreen() {
    final skillScreen = SkillsDetailScreen(bloc: detailsBloc);
    skillScreen.bloc.skill = _selectedSkill;
    skillScreen.bloc.goal = _selectedSkill.goal;
    skillScreen.bloc
        .add(GetEventsForSkillEvent(skillId: _selectedSkill.skillId));
    return skillScreen;
  }

  void viewSkill(Skill skill) async {
    _selectedSkill = skill;

    if (showSideBySide == false) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return _skillDetailsScreen();
      }));
    } else {
      setState(() {});
    }

    bloc.add(GetAllSkillsEvent());
  }
}
