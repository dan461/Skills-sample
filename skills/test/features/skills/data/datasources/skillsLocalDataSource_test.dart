import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqlite_api.dart';

class MockDatabase extends Mock implements Database{}

void main() {
  // SkillsLocalDataSourceImpl dataSourceImpl;
  // MockDatabase mockDatabase;
  // int todayInt;
  // int tomorrowInt;
  // final String skillsTable = 'skills';

  setUp(() {
    // mockDatabase = MockDatabase();
    // dataSourceImpl = SkillsLocalDataSourceImpl();
    // DateTime now = DateTime.now();
    // todayInt = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    // tomorrowInt = DateTime(now.year, now.month, now.day + 1).millisecondsSinceEpoch;
  });

  group('getAllSkills', () {
    
  });

  group('insertNewGoal', (){

    // final testGoalModel = GoalModel(id: 1, skillId: 1, fromDate: todayInt, toDate: tomorrowInt, isComplete: false,
    // timeBased: true, goalTime: 60, timeRemaining: 60);

    // test('should call insertNewGoal to cache goal', () async {
    //   dataSourceImpl.insertNewGoal(testGoalModel);
    //   verify()
    // });
  });
}
