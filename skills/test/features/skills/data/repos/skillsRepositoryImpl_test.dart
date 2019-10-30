import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skills/features/skills/data/datasources/skillsLocalDataSource.dart';
import 'package:skills/features/skills/data/repos/skillsRepositoryImpl.dart';
import 'package:skills/core/network/networkInfo.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/data/models/skillModel.dart';
import 'package:dartz/dartz.dart';

class MockLocalDataSource extends Mock implements SkillsLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  SkillsRepositoryImpl repositoryImpl;
  MockNetworkInfo mockNetworkInfo;
  MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = SkillsRepositoryImpl(
        localDataSource: mockLocalDataSource, networkInfo: mockNetworkInfo);
  });

  group('getAllSkills', (){
    final SkillModel skillModel = SkillModel(name: 'test', source: 'testing');
    final List<SkillModel> skillModelList = [skillModel];
    final Skill tSkill = skillModel;
    

    test('returns a List of Skills', () async {
      when(mockLocalDataSource.getAllSkills()).thenAnswer((_) async => skillModelList);
      final result = await repositoryImpl.getAllSkills();
      verify(mockLocalDataSource.getAllSkills());
      expect(result, equals(Right(skillModelList)));
      });
    
  });

  group('getSkillById', () {
    final SkillModel skillModel = SkillModel(name: 'test', source: 'testing');
    final Skill tSkill = skillModel;

    setUp(() {});

    test('returns list of Skills', () async {
      when(mockLocalDataSource.getSkillById(1))
          .thenAnswer((_) async => skillModel);
      final result = await repositoryImpl.getSkillById(1);

      verify(mockLocalDataSource.getSkillById(1));
      expect(result, equals(Right(tSkill)));
    });
  });

  /* TODO this is only testing for connection for now, only implementing to
      follow the course
  */
  group('downloadAllSkills', () {
    test('test for connection', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repositoryImpl.downloadAllSkills();
      verify(mockNetworkInfo.isConnected);
    });
  });
}
