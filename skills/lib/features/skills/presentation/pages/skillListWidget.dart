import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/bloc.dart';
import 'package:skills/features/skills/presentation/bloc/skills_screen/skills_bloc.dart';
import 'package:skills/features/skills/presentation/widgets/skillCell.dart';

import '../../../../service_locator.dart';
import 'skillsMasterScreen.dart';

typedef SkillSelectionCallback(Skill skill);

class SkillsList extends StatefulWidget {
  final List<Skill> skills;
  final SkillSelectionCallback callback;
  final bool showDetails;
  const SkillsList(
      {Key key,
      @required this.skills,
      @required this.callback,
      @required this.showDetails})
      : super(key: key);

  @override
  _SkillsListState createState() => _SkillsListState(callback);
}

class _SkillsListState extends State<SkillsList> {
  final SkillSelectionCallback callback;
  List<Skill> skills;
  SkillsBloc bloc;

  _SkillsListState(this.callback);

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
    return Container(
      // color: Color(0xFFFAF7F3),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return SkillCell(
                  skill: widget.skills[index],
                  callback: widget.callback,
                  showDetails: widget.showDetails,
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
