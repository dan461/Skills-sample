import 'package:skills/features/skills/data/models/skillModel.dart';
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
}


// Singleton class for providing access to sqlite database
class SkillsLocalDataSourceImpl implements SkillsLocalDataSource {
// implementing singleton pattern with a factory constructor
  static final SkillsLocalDataSourceImpl instance = new SkillsLocalDataSourceImpl.internal();
  factory SkillsLocalDataSourceImpl() => instance;
  static Database _database;
  Future<Database> tempDB() async {
    return await database;
  }

  // empty constructor
  SkillsLocalDataSourceImpl.internal();
  static final int dbVersion = 1;

  final String skillsTable = 'skills';
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
    // await db.execute(_createSessionsTable);
    // await db.execute(_createSessionSkillsJoinTable);
  }

  Future<void> deleteDatabase() async {
    await deleteDatabase();
  }

  static final String idKey = "id INTEGER PRIMARY KEY, ";
  static final String createTable = "CREATE TABLE IF NOT EXISTS";
  final String _createSkillTable = "$createTable skills($idKey "
      "name TEXT, source TEXT, startDate INTEGER, totalTime INTEGER)";

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
  Future<SkillModel> getSkillById(int id) {
    // TODO: implement getSkillById
    return null;
  }

  @override
  Future<int> insertNewSkill(Skill skill) async {
    final Database db = await database;
    final skillModel = SkillModel(name: skill.name, source: skill.source);
    int id = await db.insert(skillsTable, skillModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

}
