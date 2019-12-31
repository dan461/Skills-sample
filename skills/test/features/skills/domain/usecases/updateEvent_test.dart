import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import '../../mockClasses.dart';

void main() {
  UpdateSkillEventUC sut;
  MockEventsRepo mockEventsRepo;

  setUp(() {
    mockEventsRepo = MockEventsRepo();
    sut = UpdateSkillEventUC(mockEventsRepo);
  });

  test('test that class returns an int after updating an event', () async {
    final SkillEvent testEvent = SkillEvent(
        eventId: 1,
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: false,
        skillString: 'test');

    when(mockEventsRepo.updateEvent(testEvent)).thenAnswer((_) async => Right(1));
    final result = await sut(SkillEventInsertOrUpdateParams(event: testEvent));
    expect(result, Right(1));
    verify(mockEventsRepo.updateEvent(testEvent));
    verifyNoMoreInteractions(mockEventsRepo);
  });
}