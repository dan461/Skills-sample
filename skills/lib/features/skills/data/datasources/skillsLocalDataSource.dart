import 'package:skills/features/skills/data/models/goalModel.dart';
import 'package:skills/features/skills/data/models/sessionModel.dart';
import 'package:skills/features/skills/data/models/activityModel.dart';
import 'package:skills/features/skills/data/models/skillModel.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'dart:async';
import 'dart:io';
import 'package:synchronized/synchronized.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class SkillsLocalDataSource {
  // Throws [CacheException]
  Future<List<SkillModel>> getAllSkills();
  // Future<List<Map<String, dynamic>>> getAllSkillsInfo();
  Future<SkillModel> getSkillById(int id);
  Future<Map<String, dynamic>> getSkillGoalMapById(int id);
  Future<Skill> insertNewSkill(Skill skill);
  Future<int> deleteSkillWithId(int skillId);
  Future<int> updateSkill(int skillId, Map<String, dynamic> changeMap);
  // Goals
  Future<GoalModel> getGoalById(int id);
  Future<Goal> insertNewGoal(Goal goal);
  Future<int> updateGoal(Goal goal);
  Future<int> deleteGoalWithId(int id);
  Future<int> addGoalToSkill(int skillId, int goalId);
  // Sessions
  Future<Session> insertNewSession(Session session);
  Future<int> updateSession(Map<String, dynamic> changeMap, int id);
  Future<Session> updateAndRefreshSession(
      Map<String, dynamic> changeMap, int id);
  Future<int> completeSessionAndEvents(int sessionId, DateTime date);
  Future<SessionModel> getSessionById(int id);
  Future<int> deleteSessionWithId(int id);
  Future<List<Session>> getSessionsInMonth(DateTime month);
  Future<List<Session>> getSessionsInDateRange(
      DateTime from, DateTime to); // for calendar month mode
  Future<List<Map>> getSessionMapsInDateRange(
      DateTime from, DateTime to); // for calendar week and day modes
  // Activities
  Future<ActivityModel> insertNewActivity(Activity event);
  Future<ActivityModel> getActivityById(int id);
  Future<int> updateActivity(Map<String, dynamic> changeMap, int eventId);
  Future<int> completeActivity(
      int activityId, DateTime date, int elapsedTime, int skillId);
  Future<int> deleteActivityById(int id);
  Future<List<int>> insertActivities(List<Activity> events, int newSessionId);
  Future<List<Activity>> getActivitiesForSession(int sessionId);
  Future<List<Activity>> getCompletedActivitiesForSkill(int skillId);
  Future<List<Map>> getInfoForActivities(List<Activity> events);
  Future<List<Map>> getActivityMapsForSession(int sessionId);
  Future<List<Activity>> getActivitiesWithSkillsForSession(int sessionId);
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
  final String skillEventsTable = 'skillEvents';
  // final String sessionSkillsTable = 'session_skills';

  bool needsMigration = true;

  Future<Database> get database async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    String path = join(docsDir.path, "Skills.db");
    // using Lock to prevent race condition from async, so db is not opened twice
    final _lock = new Lock();
    if (_database == null) {
      await _lock.synchronized(() async {
        if (_database == null) {
          _database = await openDatabase(path,
              version: dbVersion, onOpen: _onOpen, onCreate: _onCreate);
        }
        if (needsMigration) {
          await _addGoalTextToGoals();
          await _dropGoalTextFromSkills();
        }
      });
    }

    return _database;
  }

  // TODO - check on ways to make this more reliable
  void _onOpen(Database db) async {
    // Enable Foreign keys, default is OFF
    await db.execute('PRAGMA foreign_keys=ON');
    _checkForeignKeysEnabled(db);
  }

  void _onCreate(Database db, int version) async {
    needsMigration = false;
    await db.execute(_createSkillTable);
    await db.execute(_createGoalTable);
    await db.execute(_createSessionsTable);
    await db.execute(_createSkillEventsTable);
  }

  void _checkForeignKeysEnabled(Database db) async {
    List<Map> result = await db.rawQuery('PRAGMA foreign_keys');
    if (result.first['foreign_keys'] == 0) {
      await db.execute('PRAGMA foreign_keys=ON');
    }
  }

  Future<void> deleteDatabase() async {
    await deleteDatabase();
  }

  static final String primaryKey = "INTEGER PRIMARY KEY";

  static final String createTable = "CREATE TABLE IF NOT EXISTS";

  // table creation
  final String _createSkillTable = "$createTable skills(skillId $primaryKey, "
      "name TEXT, type TEXT, source TEXT, instrument TEXT, startDate INTEGER, totalTime INTEGER, lastPracDate INTEGER, goalId INTEGER, priority INTEGER, proficiency INTEGER)";

  final String _createGoalTable = "$createTable goals(goalId $primaryKey, "
      "skillId INTEGER, fromDate INTEGER, toDate INTEGER, isComplete INTEGER, timeBased INTEGER, "
      "goalTime INTEGER, goalText TEXT, timeRemaining INTEGER, desc TEXT, "
      "CONSTRAINT fk_skills FOREIGN KEY (skillId) REFERENCES skills(skillId) ON DELETE CASCADE)";

  final String _createSessionsTable =
      "$createTable sessions(sessionId $primaryKey, "
      "date INTEGER, startTime INTEGER, endTime INTEGER, duration INTEGER, timeRemaining INTEGER, "
      "isScheduled INTEGER, isComplete INTEGER)";

  final String _createSkillEventsTable =
      "$createTable skillEvents(eventId $primaryKey, "
      "skillId INTEGER, sessionId INTEGER, date INTEGER, duration INTEGER, isComplete INTEGER, skillString TEXT, "
      "CONSTRAINT fk_sessions FOREIGN KEY (sessionId) REFERENCES sessions(sessionId) ON DELETE CASCADE)";

  //  ************ MIGRATIONS ****************
  Future<void> _addGoalTextToGoals() async {
    final Database db = await database;

    bool hasGoalText = await _checkTableForColumn(goalsTable, 'goalText');
    if (hasGoalText == false) {
      await db.execute("ALTER TABLE goals ADD COLUMN goalText text");
    }
  }

  Future<void> _dropGoalTextFromSkills() async {
    final Database db = await database;

    bool hasGoalText = await _checkTableForColumn(skillsTable, 'goalText');
    if (hasGoalText) {
      await db.execute("PRAGMA foreign_keys=OFF");
      await db.execute("BEGIN TRANSACTION");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS tempSkills(skillId $primaryKey, name TEXT, type TEXT, source TEXT, instrument TEXT, startDate INTEGER, "
          "totalTime INTEGER, lastPracDate INTEGER, goalId INTEGER, priority INTEGER, proficiency INTEGER)");
      await db.execute(
          "INSERT INTO tempSkills(skillId, name, type, source, instrument, startDate, totalTime, lastPracDate, goalId, priority, proficiency) "
          "SELECT skillId, name, type, source, instrument, startDate, totalTime, lastPracDate, goalId, priority, proficiency "
          "FROM skills");

      await db.execute("DROP TABLE skills");
      await db.execute("ALTER TABLE tempSkills RENAME TO skills");
      await db.execute("COMMIT");
      await db.execute("PRAGMA foreign_keys=ON");
    }
  }

  Future<bool> _checkTableForColumn(String table, String columnName) async {
    final Database db = await database;
    bool columnFound = false;
    await db.transaction((txn) async {
      List<Map> columnsList = await txn.rawQuery("pragma table_info($table)");
      for (var column in columnsList) {
        if (column['name'] == columnName) {
          columnFound = true;
          break;
        }
      }
    });
    return columnFound;
  }

// ******* SKILLS *********
  @override
  Future<List<SkillModel>> getAllSkills() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(skillsTable);
    List<SkillModel> skills = List.generate(maps.length, (i) {
      return SkillModel.fromMap(maps[i]);
    });
    for (var skill in skills) {
      if (skill.currentGoalId != 0) {
        Goal goal = await getGoalById(skill.currentGoalId);
        skill.goal = goal;
      }
    }

    return skills;
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
  Future<Map<String, dynamic>> getSkillGoalMapById(int id) async {
    SkillModel skill = await getSkillById(id);
    if (skill != null) {
      GoalModel goal = await getGoalById(skill.currentGoalId);
      Map<String, dynamic> map = {'skill': skill, 'goal': goal};

      return map;
    } else
      return null;
  }

  @override
  Future<Skill> getSkillWithGoalById(int skillId) async {
    SkillModel skill = await getSkillById(skillId);
    if (skill != null && skill.currentGoalId != 0) {
      GoalModel goal = await getGoalById(skill.currentGoalId);
      skill.goal = goal;
    }
    return skill;
  }

  @override
  Future<Skill> insertNewSkill(Skill skill) async {
    final Database db = await database;

    final SkillModel skillModel = SkillModel(
      name: skill.name,
      type: skill.type,
      source: skill.source,
      instrument: skill.instrument,
      startDate: skill.startDate,
      totalTime: 0,
      lastPracDate: DateTime.fromMillisecondsSinceEpoch(0),
      currentGoalId: 0,
      // goalText: "Goal: none",
      priority: skill.priority,
      proficiency: skill.proficiency,
    );

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
  Future<int> updateSkill(int skillId, Map<String, dynamic> changeMap) async {
    final Database db = await database;

    int updates = await db.update(skillsTable, changeMap,
        where: 'skillId = ?', whereArgs: [skillId]);
    return updates;
  }

  // ***** GOALS **********
  @override
  Future<int> deleteGoalWithId(int id) async {
    final Database db = await database;
    int result =
        await db.delete(goalsTable, where: 'goalId = ?', whereArgs: [id]);
    return result;
  }

  @override
  Future<GoalModel> getGoalById(int id) async {
    final Database db = await database;
    List<Map> maps = await db
        .query(goalsTable, columns: null, where: 'goalId = ?', whereArgs: [id]);
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
        goalText: GoalModel.translateGoal(goal),
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
    final GoalModel goalModel = GoalModel(
        goalId: goal.goalId,
        skillId: goal.skillId,
        fromDate: goal.fromDate,
        toDate: goal.toDate,
        timeBased: goal.timeBased,
        isComplete: goal.isComplete,
        goalTime: goal.goalTime,
        goalText: GoalModel.translateGoal(goal),
        timeRemaining: goal.timeRemaining,
        desc: goal.desc);
    int updates = await db.update(goalsTable, goalModel.toMap(),
        where: 'goalId = ?', whereArgs: [goal.goalId]);
    return updates;
  }

  @override
  Future<int> addGoalToSkill(int skillId, int goalId) async {
    final Database db = await database;
    Map<String, dynamic> changeMap = {'goalId': goalId};
    int updates = await db.update(skillsTable, changeMap,
        where: 'skillId = ?', whereArgs: [skillId]);
    return updates;
  }

  // ******** SESSIONS **********
  @override
  Future<Session> insertNewSession(Session session) async {
    final Database db = await database;
    SessionModel sessionModel = SessionModel(
      date: session.date,
      startTime: session.startTime,
      duration: session.duration,
      timeRemaining: session.timeRemaining,
      isComplete: session.isComplete,
      isScheduled: session.isScheduled,
    );

    int id = await db.insert(sessionsTable, sessionModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    Session newSession = await getSessionById(id);

    return newSession;
  }

  Future<int> updateSession(Map<String, dynamic> changeMap, int id) async {
    final Database db = await database;
    int response = await db.update(sessionsTable, changeMap,
        where: 'sessionId = ?', whereArgs: [id]);

    if (changeMap['isComplete'] != null) {
      int update = await db.rawUpdate(
          'UPDATE $skillEventsTable SET isComplete = 1 WHERE sessionId = $id');
      List<Map> skillIds = await db.query(skillEventsTable,
          columns: ['skillId'], where: 'sessionId = ?', whereArgs: [id]);
      print(update);
    }
    return response;
  }

  Future<Session> updateAndRefreshSession(
      Map<String, dynamic> changeMap, int id) async {
    //
    final Database db = await database;
    int response = await db.update(sessionsTable, changeMap,
        where: 'sessionId = ?', whereArgs: [id]);

    if (response != null) {
      Session refreshedSession = await getSessionById(id);
      if (changeMap['isComplete'] == true) {
        await completeSessionAndEvents(id, refreshedSession.date);
      }
      return refreshedSession;
    } else
      return null;
  }

  Future<int> completeSessionAndEvents(
      int sessionId, DateTime sessionDate) async {
    final Database db = await database;
    int dateInt = sessionDate.millisecondsSinceEpoch;

    // set session complete
    int complete = await updateSession({'isComplete': 1}, sessionId);

    // set events complete
    await db.rawUpdate(
        'UPDATE $skillEventsTable SET isComplete = 1 WHERE sessionId = $sessionId');

    // get skillIds of all Events
    List<Map> skillIds = await db.query(skillEventsTable,
        columns: ['skillId'], where: 'sessionId = ?', whereArgs: [sessionId]);

    var pracDateBatch = db.batch();
    for (var map in skillIds) {
      int skillId = map['skillId'];
      // update last practice date if new date is later than or equal to current
      pracDateBatch.rawUpdate(
          "UPDATE $skillsTable SET lastPracDate = $dateInt WHERE skillId = $skillId AND lastPracDate <= $dateInt");
    }

    await pracDateBatch.commit(noResult: true);

    return complete;
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
    final Database db = await database;
    int result =
        await db.delete(sessionsTable, where: 'sessionId = ?', whereArgs: [id]);
    return result;
  }

  Future<List<Session>> getSessionsInDateRange(
      DateTime from, DateTime to) async {
    final Database db = await database;

    List<Map> maps = await db.query(sessionsTable,
        columns: null,
        where: 'date BETWEEN ? AND ?',
        whereArgs: [from.millisecondsSinceEpoch, to.millisecondsSinceEpoch]);

    List<Session> sessionsList = [];
    if (maps.isNotEmpty) {
      for (var map in maps) {
        Session session = SessionModel.fromMap(map);
        sessionsList.add(session);
      }
    }
    return sessionsList;
  }

  Future<List<Map>> getSessionMapsInDateRange(
      DateTime from, DateTime to) async {
    List<Session> sessions = await getSessionsInDateRange(from, to);
    List<Map> sessionMaps = [];
    for (var session in sessions) {
      List<Activity> activities =
          await getActivitiesForSession(session.sessionId);
      Map<String, dynamic> sessionMap = {
        'session': session,
        'activities': activities
      };
      sessionMaps.add(sessionMap);
    }

    return sessionMaps;
  }

  Future<List<Session>> getSessionsInMonth(DateTime month) async {
    final nextMonth =
        DateTime(month.year, month.month + 1).millisecondsSinceEpoch;
    final Database db = await database;

    List<Map> maps = await db.query(sessionsTable,
        columns: null,
        where: 'date BETWEEN ? AND ?',
        whereArgs: [month.millisecondsSinceEpoch, nextMonth]);

    List<Session> sessionsList = [];
    if (maps.isNotEmpty) {
      for (var map in maps) {
        Session session = SessionModel.fromMap(map);
        sessionsList.add(session);
      }
    }
    return sessionsList;
  }

  // ******* EVENTS *********
  @override
  Future<int> deleteActivityById(int id) async {
    final Database db = await database;
    int result = await db
        .delete(skillEventsTable, where: 'eventId = ?', whereArgs: [id]);
    return result;
  }

  @override
  Future<ActivityModel> getActivityById(int id) async {
    final Database db = await database;
    List<Map> maps = await db.query(skillEventsTable,
        columns: null, where: 'eventId = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return ActivityModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<ActivityModel> insertNewActivity(Activity event) async {
    final Database db = await database;
    final model = ActivityModel(
        skillId: event.skillId,
        sessionId: event.sessionId,
        date: event.date,
        duration: event.duration,
        isComplete: event.isComplete,
        skillString: event.skillString);
    int id = await db.insert(skillEventsTable, model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    final newEvent = await getActivityById(id);
    return newEvent;
  }

  @override
  Future<List<int>> insertActivities(
      List<Activity> events, int newSessionId) async {
    final Database db = await database;
    var insertBatch = db.batch();
    for (var event in events) {
      final model = ActivityModel(
          skillId: event.skillId,
          sessionId: newSessionId,
          date: event.date,
          duration: event.duration,
          isComplete: event.isComplete,
          skillString: event.skillString);
      insertBatch.insert(skillEventsTable, model.toMap());
    }
    final resultsList = await insertBatch.commit(noResult: true);
    return resultsList;
  }

  @override
  Future<int> updateActivity(Map<String, dynamic> changeMap, activityId) async {
    final Database db = await database;
    int updates = await db.update(skillEventsTable, changeMap,
        where: 'eventId = ?', whereArgs: [activityId]);

    return updates;
  }

  @override
  Future<int> completeActivity(
      int activityId, DateTime date, int elapsedTime, int skillId) async {
    final Database db = await database;
    Map<String, dynamic> changes = {'isComplete': 1, 'duration': elapsedTime};

    int update = await db.update(skillEventsTable, changes,
        where: 'eventId = ?', whereArgs: [activityId]);
    int dateInt = date.millisecondsSinceEpoch;

    await db.rawUpdate(
        "UPDATE $skillsTable SET lastPracDate = $dateInt WHERE skillId = $skillId AND lastPracDate <= $dateInt");
    return update;
  }

  @override
  Future<List<Activity>> getActivitiesForSession(int sessionId) async {
    final Database db = await database;
    List<Map> maps = await db.query(skillEventsTable,
        where: 'sessionId = ?', whereArgs: [sessionId]);
    List<Activity> events = [];
    for (var map in maps) {
      events.add(ActivityModel.fromMap(map));
    }
    return events;
  }

  @override
  Future<List<Activity>> getCompletedActivitiesForSkill(int skillId) async {
    final Database db = await database;
    List<Map> maps = await db.query(skillEventsTable,
        where: 'skillId = ? AND isComplete = 1', whereArgs: [skillId]);

    List<Activity> events = [];
    for (var map in maps) {
      events.add(ActivityModel.fromMap(map));
    }
    return events;
  }

  // TODO - dead code?
  Future<List<Map>> getInfoForActivities(List<Activity> events) async {
    // final Database db = await database;

    List<Map> maps = [];
    for (var event in events) {
      SkillModel skill = await getSkillById(event.skillId);

      GoalModel goal;
      if (skill.currentGoalId != 0) {
        goal = await getGoalById(skill.currentGoalId);
      }

      Map<String, dynamic> eventMap = {
        'activity': event,
        'skill': skill,
        'goal': goal ?? 'none',
      };
      maps.add(eventMap);
    }

    return maps;
  }

  @override
  Future<List<Map>> getActivityMapsForSession(int sessionId) async {
    List<Activity> activities = await getActivitiesForSession(sessionId);

    List<Map> maps = [];
    for (var activity in activities) {
      Map<String, dynamic> activityMap = {
        'activity': activity,
      };
      Map<String, dynamic> skillMap =
          await getSkillGoalMapById(activity.skillId);
      activityMap.addAll(skillMap);
      maps.add(activityMap);
    }

    return maps;
  }

  @override
  Future<List<Activity>> getActivitiesWithSkillsForSession(
      int sessionId) async {
    List<Activity> activities = await getActivitiesForSession(sessionId);

    for (var activity in activities) {
      Skill skill = await getSkillWithGoalById(activity.skillId);
      activity.skill = skill;
    }

    return activities;
  }
}
