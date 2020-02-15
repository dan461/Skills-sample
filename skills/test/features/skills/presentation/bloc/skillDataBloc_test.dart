import 'package:skills/core/constants.dart';
import 'package:skills/core/enums.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/entities/skillEvent.dart';
import 'package:skills/features/skills/domain/usecases/skillEventsUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/skillDataScreen/skilldata_bloc.dart';

import '../../mockClasses.dart';

void main() {
  SkillDataBloc sut;
  MockGetCompletedEventsForSkill mockGetCompletedEventsForSkill;
  SkillEvent testEvent;

  List<SkillEvent> eventsList;

  setUp(() {
    mockGetCompletedEventsForSkill = MockGetCompletedEventsForSkill();
    sut = SkillDataBloc(
        getCompletedEventsForSkill: mockGetCompletedEventsForSkill);
    testEvent = SkillEvent(
        eventId: 1,
        skillId: 1,
        sessionId: 1,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        duration: 30,
        isComplete: true,
        skillString: 'test');

    eventsList = [testEvent];
  });

  test('bloc initial state is correct', () {
    expect(sut.initialState, equals(SkillDataInitialState()));
  });

  test(
      'test that bloc emits [SkillDataGettingEventsState, SkillDataEventsLoadedState]',
      () {
    when(mockGetCompletedEventsForSkill(GetSkillParams(id: 1)))
        .thenAnswer((_) async => Right(eventsList));
    final expected = [
      SkillDataInitialState(),
      SkillDataGettingEventsState(),
      SkillDataEventsLoadedState()
    ];
    expectLater(sut, emitsInOrder(expected));
    sut.add(GetEventsForSkillEvent(skillId: 1));
  });
}
