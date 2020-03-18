import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/data/models/activityModel.dart';
import 'package:skills/features/skills/data/repos/activityRepositoryImpl.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';

import '../../mockClasses.dart';

void main() {
  ActivityRepositoryImpl sut;
  MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    sut = ActivityRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  group('SkillEvent CRUD tests', () {
    final ActivityModel testEventModel = ActivityModel(
        eventId: 1,
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: false,
        skillString: 'test');

    final Activity testEvent = testEventModel;
    // final List<SkillEventModel> testList = [testEventModel];

    test(
        'insertEvents - calls localDataSource.insertNewActivitys, returns List<int>',
        () async {
      List<Activity> events = [testEvent];
      List<int> resultsList = [1];
      when(mockLocalDataSource.insertActivities(events, 1))
          .thenAnswer((_) async => resultsList);
      final result = await sut.insertActivities(events, 1);
      verify(mockLocalDataSource.insertActivities(events, 1));
      expect(result, equals(Right(resultsList)));
    });

    test('insertNewActivity - returns a new SkillEventModel with an id',
        () async {
      when(mockLocalDataSource.insertNewActivity(testEvent))
          .thenAnswer((_) async => testEventModel);
      final result = await sut.insertNewActivity(testEvent);
      verify(mockLocalDataSource.insertNewActivity(testEvent));
      expect(result, equals(Right(testEventModel)));
    });

    test('getEventById - returns a new SkillEventModel with correct id',
        () async {
      when(mockLocalDataSource.getActivityById(1))
          .thenAnswer((_) async => testEventModel);
      final result = await sut.getActivityById(1);
      verify(mockLocalDataSource.getActivityById(1));
      expect(result, equals(Right(testEventModel)));
    });

    test('deleteEventById - returns int of number of row changes, should be 1',
        () async {
      when(mockLocalDataSource.deleteActivityById(1)).thenAnswer((_) async => 1);
      final result = await sut.deleteActivityById(1);
      verify(mockLocalDataSource.deleteActivityById(1));
      expect(result, equals(Right(1)));
    });

    test('updateEventById - returns int of number of row changes, should be 1',
        () async {
      Map<String, dynamic> changeMap = {'isCompleted': 1};
      when(mockLocalDataSource.updateActivity(changeMap, 1))
          .thenAnswer((_) async => 1);
      final result = await sut.updateActivity(changeMap, 1);
      verify(mockLocalDataSource.updateActivity(changeMap, 1));
      expect(result, equals(Right(1)));
    });

    test('getEventsForSession - returns a list of SkillEvents', () async {
      final eventsList = [testEvent];
      when(mockLocalDataSource.getActivitiesForSession(1))
          .thenAnswer((_) async => eventsList);
      final result = await sut.getActivitiesForSession(1);
      verify(mockLocalDataSource.getActivitiesForSession(1));
      expect(result, equals(Right(eventsList)));
    });

    test(
        'getCompletedActivitiesForSkill - returns a list of completed activities for a Skill',
        () async {
      final eventsList = [testEvent];
      when(mockLocalDataSource.getCompletedActivitiesForSkill(1))
          .thenAnswer((_) async => eventsList);
      final result = await sut.getCompletedActivitiesForSkill(1);
      verify(mockLocalDataSource.getCompletedActivitiesForSkill(1));
      expect(result, equals(Right(eventsList)));
    });
  });
}
