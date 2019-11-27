import 'package:flutter_test/flutter_test.dart';
import 'package:skills/features/skills/data/datasources/skillsLocalDataSource.dart';

void main() {
  SkillsLocalDataSourceImpl dataSourceImpl;

  setUp(() {
    dataSourceImpl = SkillsLocalDataSourceImpl();
  });

  group('getAllSkills', () {
    test('returns a List of Skills from local database', () async {});
  });
}
