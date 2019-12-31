import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/data/models/skillEventModel.dart';
import 'package:skills/features/skills/data/repos/skillEventRepositoryImpl.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';

import '../../mockClasses.dart';

void main() {
  SkillEventRepositoryImpl sut;
  MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    sut = SkillEventRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  group('SkillEvent CRUD tests', () {
    final SkillEventModel testEventModel = SkillEventModel(
        eventId: 1,
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: false,
        skillString: 'test');

    final SkillEvent testEvent = testEventModel;
    // final List<SkillEventModel> testList = [testEventModel];

    test(
        'insertEvents - calls localDataSource.insertNewEvents, returns List<int>',
        () async {
      List<SkillEvent> events = [testEvent];
      List<int> resultsList = [1];
      when(mockLocalDataSource.insertEvents(events, 1))
          .thenAnswer((_) async => resultsList);
      final result = await sut.insertEvents(events, 1);
      verify(mockLocalDataSource.insertEvents(events, 1));
      expect(result, equals(Right(resultsList)));
    });

    test('insertNewEvent - returns a new SkillEventModel with an id', () async {
      when(mockLocalDataSource.insertNewEvent(testEvent))
          .thenAnswer((_) async => testEventModel);
      final result = await sut.insertNewEvent(testEvent);
      verify(mockLocalDataSource.insertNewEvent(testEvent));
      expect(result, equals(Right(testEventModel)));
    });

    test('getEventById - returns a new SkillEventModel with correct id',
        () async {
      when(mockLocalDataSource.getEventById(1))
          .thenAnswer((_) async => testEventModel);
      final result = await sut.getEventById(1);
      verify(mockLocalDataSource.getEventById(1));
      expect(result, equals(Right(testEventModel)));
    });

    test('deleteEventById - returns int of number of row changes, should be 1',
        () async {
      when(mockLocalDataSource.deleteEventById(1)).thenAnswer((_) async => 1);
      final result = await sut.deleteEventById(1);
      verify(mockLocalDataSource.deleteEventById(1));
      expect(result, equals(Right(1)));
    });

    test('updateEventById - returns int of number of row changes, should be 1',
        () async {
      when(mockLocalDataSource.updateEvent(testEvent))
          .thenAnswer((_) async => 1);
      final result = await sut.updateEvent(testEvent);
      verify(mockLocalDataSource.updateEvent(testEvent));
      expect(result, equals(Right(1)));
    });
  });
}
