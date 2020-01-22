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
    Map<String, dynamic> changeMap = {'isCompleted': 1};

    when(mockEventsRepo.updateEvent(changeMap, 1))
        .thenAnswer((_) async => Right(1));
    final result = await sut(SkillEventUpdateParams(changeMap, 1));
    expect(result, Right(1));
    verify(mockEventsRepo.updateEvent(changeMap, 1));
    verifyNoMoreInteractions(mockEventsRepo);
  });
}
