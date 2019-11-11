import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';


class SkillsScreen extends StatefulWidget {
  @override
  _SkillsScreenState createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  // DbHelper helper = DbHelper.instance;
  // final skillData = SkillData();

  // void addSkill() {
  //   skillData.addNewSkill('Newest', 'kdkdkkd');
  //  showModalBottomSheet(
  //      context: context,
  //       builder: (context) {
  //         return Container();
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          
//          skillData.addNewSkill('NEWWW', 'jdjdjdjd');
        },
      ),
      body: Container(
        child: new SkillsList(),
      ),
    );
  }
}

class SkillsList extends StatefulWidget {
  const SkillsList({
    Key key,
  }) : super(key: key);

  @override
  _SkillsListState createState() => _SkillsListState();
}

class _SkillsListState extends State<SkillsList> {
  // static DbHelper helper = DbHelper.instance;

  Future<List<Skill>> _allSkills;
//  SkillData _skillData;

  @override
  void initState() {
    super.initState();
    // SkillData skillData = SkillData();
    // _allSkills = skillData.skills;
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
    return FutureBuilder<List<Skill>>(
      future: _allSkills,
      builder: (BuildContext context, AsyncSnapshot<List<Skill>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Container(
              color: Colors.grey[200],
              margin: EdgeInsets.fromLTRB(4, 2, 4, 4),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return SkillCell(
                          skill: snapshot.data[index],
                        );
                      },
                      itemCount: snapshot.data.length,
                    ),
                  ),
                ],
              ),
            );
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          case ConnectionState.active:
            break;
          case ConnectionState.none:
            break;
        }
        return null;
      },
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
