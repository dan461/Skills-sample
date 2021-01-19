import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/core/tickTock.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/activityUseCases.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/actvityEditor/activityeditor_bloc.dart';

import '../../mockClasses.dart';

void main() {
  ActivityEditorBloc sut;
  MockUpdateActivityUC mockUpdateActivityUC;
  Activity testActivity;
  Skill testSkill;
  Skill testSkill2;

  setUp(() {
    testSkill = Skill(
        skillId: 1, name: 'test', type: 'test', startDate: TickTock.today());
    testSkill2 = Skill(
        skillId: 2, name: 'test', type: 'test', startDate: TickTock.today());
    testActivity = Activity(
        eventId: 1,
        skillId: 1,
        sessionId: 1,
        date: TickTock.today(),
        duration: 20,
        isComplete: true,
        skillString: 'skill',
        skill: testSkill,
        notes: 'notes');
    mockUpdateActivityUC = MockUpdateActivityUC();
    sut = ActivityEditorBloc(updateActivityUC: mockUpdateActivityUC);
    sut.activity = testActivity;
    sut.selectedDuration = testActivity.duration;
    sut.selectedSkill = testSkill;
    sut.selectedNotes = 'notes';
  });

  group('ActivityEditorBloc changeMap tests', () {
    test(
        'test that getChangeMap function returns correct map when the Activity duration has changed',
        () {
      sut.selectedDuration = 25;
      Map<String, dynamic> map = sut.getChangeMap();
      expect(map['duration'], equals(25));
    });

    test(
        'test that getChangeMap function returns correct map when the Activity duration has changed and then returns to original value',
        () {
      sut.selectedDuration = 25;
      sut.selectedDuration = 20;
      Map<String, dynamic> map = sut.getChangeMap();
      expect(map['duration'], null);
    });

    test(
        'test that getChangeMap function returns correct map when the Activity notes have changed',
        () {
      sut.selectedNotes = 'new notes';
      Map<String, dynamic> map = sut.getChangeMap();
      expect(map['notes'], equals('new notes'));
    });

    test(
        'test that getChangeMap function returns correct map when the Activity Skill has changed',
        () {
      sut.selectedSkill = testSkill2;
      Map<String, dynamic> map = sut.getChangeMap();
      expect(map['skillId'], equals(2));
    });
  });

  group('UpdateActivityUC - ', () {
    Map<String, dynamic> map = {};
    map['duration'] = 25;
    test(
        'test that UpdateActivityUC is called after a ActivityEditorSaveEvent is added',
        () async {
      sut.selectedDuration = 25;

      sut.add(ActivityEditorSaveEvent());
      await untilCalled(mockUpdateActivityUC(
          ActivityUpdateParams(changeMap: map, activityId: 1)));
      verify(mockUpdateActivityUC(
          ActivityUpdateParams(changeMap: map, activityId: 1)));
    });

    test(
        'test that bloc emits [ActivityEditorCrudInProgressState, ActivityEditorUpdateCompleteState] after successful update.',
        () async {
          sut.selectedDuration = 25;
      when(mockUpdateActivityUC(
              ActivityUpdateParams(changeMap: map, activityId: 1)))
          .thenAnswer((_) async => Right(1));
      final expected = [
        ActivityEditorInitial(),
        ActivityEditorCrudInProgressState(),
        ActivityEditorUpdateCompleteState()
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(ActivityEditorSaveEvent());
    });

    test(
        'test that bloc emits [ActivityEditorCrudInProgressState, ActivityEditorErrorState] after unsuccessful update.',
        () async {
          sut.selectedDuration = 25;
      when(mockUpdateActivityUC(
              ActivityUpdateParams(changeMap: map, activityId: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        ActivityEditorInitial(),
        ActivityEditorCrudInProgressState(),
        ActivityEditorErrorState(CACHE_FAILURE_MESSAGE)
      ];
      expectLater(sut, emitsInOrder(expected));
      sut.add(ActivityEditorSaveEvent());
    });
  });
}
