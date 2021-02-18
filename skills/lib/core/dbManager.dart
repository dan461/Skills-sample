import 'package:flutter/material.dart';
import 'package:flutter_sqflite_manager/flutter_sqflite_manager.dart';
import 'package:skills/features/skills/data/datasources/skillsLocalDataSource.dart';
import 'package:skills/features/skills/presentation/pages/baseScreen.dart';
import 'package:sqflite/sqlite_api.dart';

class DbManager extends StatefulWidget {
  @override
  _DbManagerState createState() => _DbManagerState();
}

class _DbManagerState extends State<DbManager> {
  SkillsLocalDataSourceImpl dataSourceImpl = SkillsLocalDataSourceImpl.instance;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Database>(
      future: dataSourceImpl.tempDB(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SqfliteManager(
            database: snapshot.data,
            enable: false,
            child: BaseScreen(),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
