import 'package:skills/features/skills/data/models/goalModel.dart';
import 'package:skills/features/skills/data/models/sessionModel.dart';
import 'package:skills/features/skills/data/models/skillModel.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
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
  Future<Skill> insertNewSkill(Skill skill);
  Future<int> deleteSkillWithId(int skillId);
  Future<int> updateSkill(Skill skill);
  Future<GoalModel> getGoalById(int id);
  Future<Goal> insertNewGoal(Goal goal);
  Future<int> updateGoal(Goal goal);
  Future<int> deleteGoalWithId(int id);
  Future<int> addGoalToSkill(int skillId, int goalId, String goalText);
  Future<Session> insertNewSession(Session session);
  Future<SessionModel> getSessionById(int id);
  Future<int> deleteSessionWithId(int id);
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
    await db.execute(_createSessionsTable);

    // await db.execute(_createSessionsTable);
    // await db.execute(_createSessionSkillsJoinTable);
  }

  Future<void> deleteDatabase() async {
    await deleteDatabase();
  }

  static final String primaryKey = "INTEGER PRIMARY KEY";
  static final String idKey = "id $primaryKey, ";
  static final String integer = "INTEGER";
  static final String createTable = "CREATE TABLE IF NOT EXISTS";

  // table creation
  final String _createSkillTable = "$createTable skills(skillId $primaryKey, "
      "name TEXT, source TEXT, startDate INTEGER, totalTime INTEGER, lastPracDate INTEGER, currentGoalId $integer, goalText TEXT)";

  final String _createGoalTable = "$createTable goals($idKey "
      "skillId $integer, fromDate $integer, toDate $integer, isComplete $integer, timeBased $integer, "
      "goalTime $integer, timeRemaining $integer, desc TEXT, "
      "CONSTRAINT fk_skills FOREIGN KEY (skillId) REFERENCES skills(skillId) ON DELETE CASCADE)";

  final String _createSessionsTable =
      "$createTable sessions(sessionId $primaryKey, "
      "date $integer, startTime INTEGER, endTime INTEGER, duration INTEGER, timeRemaining INTEGER, "
      "isScheduled INTEGER, isCompleted INTEGER)";

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
        columns: null, where: 'skillId = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return SkillModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<Skill> insertNewSkill(Skill skill) async {
    final Database db = await database;
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final SkillModel skillModel = SkillModel(
        name: skill.name,
        source: skill.source,
        startDate: today.millisecondsSinceEpoch,
        totalTime: 0,
        lastPracDate: 0,
        currentGoalId: 0,
        goalText: "Goal: none");

    int id = await db.insert(skillsTable, skillModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    Skill newSkill = await getSkillById(id);

    return newSkill;
  }

  @override
  Future<int> deleteSkillWithId(int skillId) async {
    final Database db = await database;
    int result = await db
        .delete(skillsTable, where: 'skillId = ?', whereArgs: [skillId]);
    return result;
  }

  @override
  Future<int> updateSkill(Skill skill) async {
    final Database db = await database;
    final SkillModel skillModel = SkillModel(
        id: skill.id,
        name: skill.name,
        source: skill.source,
        startDate: skill.startDate,
        totalTime: skill.totalTime,
        lastPracDate: skill.lastPracDate,
        currentGoalId: skill.currentGoalId,
        goalText: skill.goalText);
    int updates = await db.update(skillsTable, skillModel.toMap(),
        where: 'skillId = ?', whereArgs: [skillModel.id]);
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
  Future<Goal> insertNewGoal(Goal goal) async {
    final Database db = await database;
    final GoalModel goalModel = GoalModel(
        skillId: goal.skillId,
        fromDate: goal.fromDate,
        toDate: goal.toDate,
        timeBased: goal.timeBased,
        isComplete: false,
        goalTime: goal.goalTime,
        timeRemaining: goal.goalTime,
        desc: goal.desc != null ? goal.desc : "");

    int id = await db.insert(goalsTable, goalModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    Goal newGoal = await getGoalById(id);
    return newGoal;
  }

  @override
  Future<int> updateGoal(Goal goal) async {
    final Database db = await database;
    final GoalModel goalModel = goal;
    int updates = await db.update(goalsTable, goalModel.toMap(),
        where: 'id = ?', whereArgs: [goal.id]);
    return updates;
  }

  @override
  Future<int> addGoalToSkill(int skillId, int goalId, String goalText) async {
    final Database db = await database;
    Map<String, dynamic> changeMap = {
      'currentGoalId': goalId,
      'goalText': goalText
    };
    int updates = await db.update(skillsTable, changeMap,
        where: 'skillId = ?', whereArgs: [skillId]);
    return updates;
  }

  @override
  Future<Session> insertNewSession(Session session) async {
    final Database db = await database;
    SessionModel sessionModel;
    int id = await db.insert(sessionsTable, sessionModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    Session newSession = await getSessionById(id);

    return newSession;
  }

  Future<SessionModel> getSessionById(int id) async {
    final Database db = await database;
    List<Map> maps = await db.query(sessionsTable,
        columns: null, where: 'sessionId = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return SessionModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteSessionWithId(int id) async {
    
  }

  // @override
  // Future<int> addGoalToSkill(int skillId, int goalId) async {
  //   final Database db = await database;
  //   int newId;
  //   await db.transaction((txn) async {
  //     newId = await txn.rawInsert(
  //         'INSERT INTO $skillsGoalsTable(skill_id, goal_id) VALUES ($skillId, $goalId)');
  //   });

  //   // Skill skill = await getSkillById(skillId);
  //   // int updates = await update

  //   return newId;
  // }

}
