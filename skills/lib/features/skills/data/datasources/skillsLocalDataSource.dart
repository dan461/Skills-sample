import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/data/models/goalModel.dart';
import 'package:skills/features/skills/data/models/skillModel.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'dart:async';
import 'dart:io';
import 'package:synchronized/synchronized.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class SkillsLocalDataSource {
  // Throws [CacheException]
  Future<List<SkillModel>> getAllSkills();
  Future<SkillModel> getSkillById(int id);
  Future<int> insertNewSkill(Skill skill);
  Future<int> updateSkill(Skill skill);
  // Future<int> updateSkill(int skillId, Map changeMap);
  Future<GoalModel> getGoalById(int id);
  Future<int> insertNewGoal(Goal goal);
  Future<int> updateGoal(Goal goal);
  Future<int> deleteGoalWithId(int id);
  Future<int> addGoalToSkill(int skillId, int goalId);
}

// Singleton class for providing access to sqlite database
class SkillsLocalDataSourceImpl implements SkillsLocalDataSource {
// implementing singleton pattern with a factory constructor
  static final SkillsLocalDataSourceImpl instance =
      new SkillsLocalDataSourceImpl.internal();
  factory SkillsLocalDataSourceImpl() => instance;
  static Database _database;
  Future<Database> tempDB() async {
    return await database;
  }

  // empty constructor
  SkillsLocalDataSourceImpl.internal();
  static final int dbVersion = 1;

  final String skillsTable = 'skills';
  final String goalsTable = 'goals';
  final String skillsGoalsTable = 'skills_goals';
  final String sessionsTable = 'sessions';
  final String sessionSkillsTable = 'session_skills';
  final String columnId = 'id';

  Future<Database> get database async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    String path = join(docsDir.path, "Skills.db");
    // using Lock to prevent race condition from async, so db is not opened twice
    final _lock = new Lock();
    if (_database == null) {
      await _lock.synchronized(() async {
        if (_database == null) {
          _database = await openDatabase(path,
              version: dbVersion, onOpen: (db) {}, onCreate: _onCreate);
        }
      });
    }
    return _database;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(_createSkillTable);
    await db.execute(_createGoalTable);
    await db.execute(_createSkillsGoalsJoinTable);
    // await db.execute(_createSessionsTable);
    // await db.execute(_createSessionSkillsJoinTable);
  }

  Future<void> deleteDatabase() async {
    await deleteDatabase();
  }

  static final String idKey = "id INTEGER PRIMARY KEY, ";
  static final String integer = "INTEGER";
  static final String createTable = "CREATE TABLE IF NOT EXISTS";

  // table creation
  final String _createSkillTable = "$createTable skills($idKey "
      "name TEXT, source TEXT, startDate INTEGER, totalTime INTEGER, currentGoalId $integer, goalText TEXT)";

  final String _createGoalTable = "$createTable goals($idKey "
      "fromDate $integer, toDate $integer, isComplete $integer, timeBased $integer, "
      "goalTime $integer, timeRemaining $integer, desc TEXT)";

  final String _createSkillsGoalsJoinTable = "$createTable skills_goals($idKey"
      "skill_id $integer, goal_id $integer)";

  // final String _createSessionsTable = "$createTable sessions($idKey"
  //     "name TEXT, duration INTEGER, fromTime INTEGER, toTime INTEGER, "
  //     "isScheduled INTEGER, isCompleted INTEGER, timeRemaining INTEGER)";

  // final String _createSessionSkillsJoinTable =
  //     "$createTable session_skills($idKey"
  //     "skill_Id INTEGER, session_Id INTEGER)";

  @override
  Future<List<SkillModel>> getAllSkills() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(skillsTable);

    return List.generate(maps.length, (i) {
      return SkillModel.fromMap(maps[i]);
    });
    // return null;
  }

  @override
  Future<SkillModel> getSkillById(int id) async {
    final Database db = await database;
    List<Map> maps = await db.query(skillsTable,
        columns: null, where: '$columnId = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return SkillModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<int> insertNewSkill(Skill skill) async {
    final Database db = await database;
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final SkillModel skillModel = SkillModel(
        name: skill.name,
        source: skill.source,
        startDate: today.millisecondsSinceEpoch,
        totalTime: 0,
        currentGoalId: 0,
        goalText: "none");

    int id = await db.insert(skillsTable, skillModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  // @override
  // Future<int> updateSkill(int skillId, Map changeMap) async {
  //   final Database db = await database;
  //   int updates = await db.update(skillsTable, changeMap, where:'$columnId = ?', whereArgs: [skillId]);
  //   return updates;
  // }

  @override
  Future<int> updateSkill(Skill skill) async {
    final Database db = await database;
    final SkillModel skillModel = SkillModel(
        name: skill.name,
        source: skill.source,
        startDate: skill.startDate,
        totalTime: skill.totalTime,
        currentGoalId: skill.currentGoalId,
        goalText: skill.goalText);
    int updates = await db.update(skillsTable, skillModel.toMap());
    return updates;
  }

  @override
  Future<int> deleteGoalWithId(int id) async {
    final Database db = await database;
    int result =
        await db.delete(goalsTable, where: '$columnId = ?', whereArgs: [id]);
    return result;
  }

  @override
  Future<GoalModel> getGoalById(int id) async {
    final Database db = await database;
    List<Map> maps = await db.query(goalsTable,
        columns: null, where: '$columnId = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return GoalModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<int> insertNewGoal(Goal goal) async {
    final Database db = await database;
    final GoalModel goalModel = GoalModel(
        fromDate: goal.fromDate,
        toDate: goal.toDate,
        timeBased: goal.timeBased,
        isComplete: false,
        goalTime: goal.goalTime,
        desc: goal.desc != null ? goal.desc : "");
    int id = await db.insert(goalsTable, goalModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  @override
  Future<int> updateGoal(Goal goal) async {
    final Database db = await database;
    final GoalModel goalModel = goal;
    // TODO - any WHERE needed? or conflict alg?
    int updates = await db.update(goalsTable, goalModel.toMap());
    return updates;
  }

  @override
  Future<int> addGoalToSkill(int skillId, int goalId) async {
    final Database db = await database;
    int newId;
    await db.transaction((txn) async {
      newId = await txn.rawInsert(
          'INSERT INTO $skillsGoalsTable(skill_id, goal_id) VALUES ($skillId, $goalId)');
    });

    // Skill skill = await getSkillById(skillId);
    // int updates = await update

    return newId;
  }
}
