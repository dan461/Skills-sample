import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import '../../mockClasses.dart';

void main() {
  DeleteEventByIdUC sut;
  MockEventsRepo mockEventsRepo;

  setUp(() {
    mockEventsRepo = MockEventsRepo();
    sut = DeleteEventByIdUC(mockEventsRepo);
  });

  test('test that class returns an int after updating an event', () async {
    when(mockEventsRepo.deleteEventById(1)).thenAnswer((_) async => Right(1));
    final result = await sut(SkillEventGetOrDeleteParams(eventId: 1));
    expect(result, Right(1));
    verify(mockEventsRepo.deleteEventById(1));
    verifyNoMoreInteractions(mockEventsRepo);
  });
}
