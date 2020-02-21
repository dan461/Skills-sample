import 'package:skills/features/skills/data/models/goalModel.dart';
import 'package:skills/features/skills/data/models/sessionModel.dart';
import 'package:skills/features/skills/data/models/skillEventModel.dart';
import 'package:skills/features/skills/data/models/skillModel.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
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
  Future<int> updateSession(Map<String, dynamic> changeMap, int id);
  Future<int> completeSessionAndEvents(int sessionId, DateTime date);
  Future<SessionModel> getSessionById(int id);
  Future<int> deleteSessionWithId(int id);
  Future<List<Session>> getSessionsInMonth(DateTime month);
  Future<List<Session>> getSessionsInDateRange(
      DateTime from, DateTime to); // for calendar month mode
  Future<List<Map>> getSessionMapsInDateRange(
      DateTime from, DateTime to); // for calendar week and day modes
  Future<SkillEventModel> insertNewEvent(SkillEvent event);
  Future<SkillEventModel> getEventById(int id);
  Future<int> updateEvent(Map<String, dynamic> changeMap, int eventId);
  Future<int> deleteEventById(int id);
  Future<List<int>> insertEvents(List<SkillEvent> events, int newSessionId);
  Future<List<SkillEvent>> getEventsForSession(int sessionId);
  Future<List<SkillEvent>> getCompletedActivitiesForSkill(int skillId);
  Future<List<Map>> getInfoForEvents(List<SkillEvent> events);
  Future<List<Map>> getEventMapsForSession(int sessionId);
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
  // static final String idKey = "id $primaryKey, ";
  // static final String integer = "INTEGER";
  static final String createTable = "CREATE TABLE IF NOT EXISTS";

  // static final String skillId = 'skillId';
  // static final String sessionId = 'sessionId';
  // static final String goalId = 'goalId';
  // static final String eventId = 'eventId';

  // table creation
  final String _createSkillTable = "$createTable skills(skillId $primaryKey, "
      "name TEXT, type TEXT, source TEXT, instrument TEXT, startDate INTEGER, totalTime INTEGER, lastPracDate INTEGER, goalId INTEGER, goalText TEXT, priority INTEGER, proficiency INTEGER)";

  final String _createGoalTable = "$createTable goals(goalId $primaryKey, "
      "skillId INTEGER, fromDate INTEGER, toDate INTEGER, isComplete INTEGER, timeBased INTEGER, "
      "goalTime INTEGER, timeRemaining INTEGER, desc TEXT, "
      "CONSTRAINT fk_skills FOREIGN KEY (skillId) REFERENCES skills(skillId) ON DELETE CASCADE)";

  final String _createSessionsTable =
      "$createTable sessions(sessionId $primaryKey, "
      "date INTEGER, startTime INTEGER, endTime INTEGER, duration INTEGER, timeRemaining INTEGER, "
      "isScheduled INTEGER, isComplete INTEGER)";

  final String _createSkillEventsTable =
      "$createTable skillEvents(eventId $primaryKey, "
      "skillId INTEGER, sessionId INTEGER, date INTEGER, duration INTEGER, isComplete INTEGER, skillString TEXT, "
      "CONSTRAINT fk_sessions FOREIGN KEY (sessionId) REFERENCES sessions(sessionId) ON DELETE CASCADE)";

// ******* SKILLS *********
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

    final SkillModel skillModel = SkillModel(
      name: skill.name,
      type: skill.type,
      source: skill.source,
      instrument: skill.instrument,
      startDate: skill.startDate,
      totalTime: 0,
      lastPracDate: DateTime.fromMillisecondsSinceEpoch(0),
      currentGoalId: 0,
      goalText: "Goal: none",
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
  Future<int> updateSkill(Skill skill) async {
    final Database db = await database;
    final SkillModel skillModel = SkillModel(
      skillId: skill.skillId,
      name: skill.name,
      type: skill.type,
      source: skill.source,
      instrument: skill.instrument,
      startDate: skill.startDate,
      totalTime: skill.totalTime,
      lastPracDate: skill.lastPracDate,
      currentGoalId: skill.currentGoalId,
      goalText: skill.goalText,
      priority: skill.priority,
      proficiency: skill.proficiency,
    );
    int updates = await db.update(skillsTable, skillModel.toMap(),
        where: 'skillId = ?', whereArgs: [skillModel.skillId]);
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
        timeRemaining: goal.timeRemaining,
        desc: goal.desc);
    int updates = await db.update(goalsTable, goalModel.toMap(),
        where: 'goalId = ?', whereArgs: [goal.goalId]);
    return updates;
  }

  @override
  Future<int> addGoalToSkill(int skillId, int goalId, String goalText) async {
    final Database db = await database;
    Map<String, dynamic> changeMap = {'goalId': goalId, 'goalText': goalText};
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
      endTime: session.endTime,
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

  Future<int> completeSessionAndEvents(
      int sessionId, DateTime sessionDate) async {
    final Database db = await database;
    int dateInt = sessionDate.millisecondsSinceEpoch;

    // set session complete
    int complete = await updateSession({'isComplete': 1}, sessionId);

    // set events complete
    int update = await db.rawUpdate(
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

    List<int> updates = await pracDateBatch.commit(noResult: true);

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
      List<SkillEvent> events = await getEventsForSession(session.sessionId);
      Map<String, dynamic> sessionMap = {'session': session, 'events': events};
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
  Future<int> deleteEventById(int id) async {
    final Database db = await database;
    int result = await db
        .delete(skillEventsTable, where: 'eventId = ?', whereArgs: [id]);
    return result;
  }

  @override
  Future<SkillEventModel> getEventById(int id) async {
    final Database db = await database;
    List<Map> maps = await db.query(skillEventsTable,
        columns: null, where: 'eventId = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return SkillEventModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<SkillEventModel> insertNewEvent(SkillEvent event) async {
    final Database db = await database;
    final model = SkillEventModel(
        skillId: event.skillId,
        sessionId: event.sessionId,
        date: event.date,
        duration: event.duration,
        isComplete: event.isComplete,
        skillString: event.skillString);
    int id = await db.insert(skillEventsTable, model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    final newEvent = await getEventById(id);
    return newEvent;
  }

  @override
  Future<List<int>> insertEvents(
      List<SkillEvent> events, int newSessionId) async {
    final Database db = await database;
    var insertBatch = db.batch();
    for (var event in events) {
      final model = SkillEventModel(
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
  Future<int> updateEvent(Map<String, dynamic> changeMap, eventId) async {
    final Database db = await database;
    int updates = await db.update(skillEventsTable, changeMap,
        where: 'eventId = ?', whereArgs: [eventId]);
    return updates;
  }

  @override
  Future<List<SkillEvent>> getEventsForSession(int sessionId) async {
    final Database db = await database;
    List<Map> maps = await db.query(skillEventsTable,
        where: 'sessionId = ?', whereArgs: [sessionId]);
    List<SkillEvent> events = [];
    for (var map in maps) {
      events.add(SkillEventModel.fromMap(map));
    }
    return events;
  }

  @override
  Future<List<SkillEvent>> getCompletedActivitiesForSkill(int skillId) async {
    final Database db = await database;
    List<Map> maps = await db.query(skillEventsTable,
        where: 'skillId = ? AND isComplete = 1', whereArgs: [skillId]);

    List<SkillEvent> events = [];
    for (var map in maps) {
      events.add(SkillEventModel.fromMap(map));
    }
    return events;
  }

  // TODO - dead code?
  Future<List<Map>> getInfoForEvents(List<SkillEvent> events) async {
    // final Database db = await database;

    List<Map> maps = [];
    for (var event in events) {
      SkillModel skill = await getSkillById(event.skillId);

      GoalModel goal;
      if (skill.currentGoalId != 0) {
        goal = await getGoalById(skill.currentGoalId);
      }

      Map<String, dynamic> eventMap = {
        'event': event,
        'skill': skill,
        'goal': goal ?? 'none',
      };
      maps.add(eventMap);
    }

    return maps;
  }

  @override
  Future<List<Map>> getEventMapsForSession(int sessionId) async {
    List<SkillEvent> events = await getEventsForSession(sessionId);

    List<Map> maps = [];
    for (var event in events) {
      SkillModel skill = await getSkillById(event.skillId);

      GoalModel goal;
      if (skill.currentGoalId != 0) {
        goal = await getGoalById(skill.currentGoalId);
      }

      Map<String, dynamic> eventMap = {
        'event': event,
        'skill': skill,
        'goal': goal ?? 'none',
      };
      maps.add(eventMap);
    }

    return maps;
  }

  // Future<List<Map>> getInfoForEvents(List<SkillEvent> events) async {
  //   final Database db = await database;

  //   List<Map> maps = [];
  //   for (var event in events) {
  //     // Get the id for the Skill's current goal, so only that one will be selected

  //     List<Map> currentGoalMapList = await db.query(skillsTable,
  //         columns: ['goalId'],
  //         where: 'skillId = ?',
  //         whereArgs: [event.skillId]);

  //     var currentGoalId = currentGoalMapList.first['goalId'];

  //     var query;
  //     if (currentGoalId > 0) {
  //         query =
  //         "SELECT name, source, goalText, timeRemaining FROM $skillsTable "
  //         "INNER JOIN $goalsTable ON skills.skillId = goals.skillId "
  //         "WHERE skills.skillId = ?";
  //     } else {
  //       query = "SELECT name, source FROM $skillsTable WHERE skillId = ?";
  //     }

  //     List<Map> infomaps =
  //         await db.rawQuery(query, [event.skillId]);

  //     var skillName = '';
  //     var skillSource = '';
  //     var goalText = '';
  //     var time = 0;

  //     if (infomaps.isNotEmpty) {
  //       skillName = infomaps.first['name'];
  //       skillSource = infomaps.first['source'];
  //       goalText = infomaps.first['goalText'] ?? 'None';
  //       time = infomaps.first['timeRemaining'] ?? 0;
  //     }

  //     Map<String, dynamic> eventMap = {
  //       'event': event,
  //       'skillName': skillName,
  //       'source': skillSource,
  //       'goalText': goalText,
  //       'time': time
  //     };
  //     maps.add(eventMap);
  //   }

  //   return maps;
  // }
}
