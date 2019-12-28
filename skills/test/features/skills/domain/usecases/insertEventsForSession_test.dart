import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import '../../mockClasses.dart';

void main() {
  InsertEventsForSessionUC sut;
  MockEventsRepo mockEventsRepo;

  setUp(() {
    mockEventsRepo = MockEventsRepo();
    sut = InsertEventsForSessionUC(mockEventsRepo);
  });

  test('test that class calls repo insertEvents()', () async {
    final SkillEvent testEvent = SkillEvent(
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: false,
        skillString: 'test');
    final events = [testEvent];
    final list = [1];
    when(mockEventsRepo.insertEvents(events, 1))
        .thenAnswer((_) async => Right(list));
    final result =
        await sut(SkillEventMultiInsertParams(events: events, newSessionId: 1));
    expect(result, Right(list));
    verify(mockEventsRepo.insertEvents(events, 1));
    verifyNoMoreInteractions(mockEventsRepo);
  });
}
