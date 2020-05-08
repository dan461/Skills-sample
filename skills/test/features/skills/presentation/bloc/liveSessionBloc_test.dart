import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/activeSessionScreen/activesession_bloc.dart';
import 'package:skills/features/skills/presentation/bloc/liveSessionScreen/liveSessionScreen_bloc.dart';
import '../../mockClasses.dart';

void main() {
  LiveSessionScreenBloc sut;
  MockSaveLiveSessionWithActivities mockSaveLiveSessionWithActivities;
  Skill testSkill;
  Activity testActivity;
  Session testSession;
  List<Activity> testActivitiesList;

  setUp(() {
    mockSaveLiveSessionWithActivities = MockSaveLiveSessionWithActivities();
    sut = LiveSessionScreenBloc(
        saveLiveSessionWithActivitiesUC: mockSaveLiveSessionWithActivities);

    testSkill = Skill(
        name: 'test',
        type: 'Composition',
        startDate: DateTime.fromMillisecondsSinceEpoch(0));

    testSession = Session(
        date: DateTime.now(),
        startTime: TimeOfDay(hour: 12, minute: 0),
        duration: 30,
        isComplete: true,
        isScheduled: true);

    testActivity = Activity(
        skillId: 1,
        sessionId: 0,
        duration: 30,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        isComplete: false,
        skillString: 'test');

    testActivitiesList = [testActivity];
  });

  test('test for correct initial state', () {
    expect(sut.initialState, equals(LiveSessionScreenInitial()));
  });

  test(
      'test bloc emits LiveSessionReadyState after LiveSessionActivitySelectedEvent is added',
      () async {
    final expected = [LiveSessionScreenInitial(), LiveSessionReadyState()];
    expectLater(sut, emitsInOrder(expected));
    sut.add(LiveSessionSkillSelectedEvent(skill: testSkill));
  });

  test(
      'test bloc emits [LiveSessionSelectOrFinishState] after a LiveSessionActivityFinishedEvent is added',
      () async {
    sut.selectedSkill = testSkill;
    final expected = [
      LiveSessionScreenInitial(),
      LiveSessionSelectOrFinishState()
    ];
    expectLater(sut, emitsInOrder(expected));
    sut.add(LiveSessionActivityFinishedEvent(elapsedTime: 30, notes: ''));
  });

  test(
      'test bloc emits [LiveSessionSelectOrFinishState] after a LiveSessionActivityCancelledEvent is added',
      () async {
    sut.selectedSkill = testSkill;
    final expected = [
      LiveSessionScreenInitial(),
      LiveSessionSelectOrFinishState()
    ];
    expectLater(sut, emitsInOrder(expected));
    sut.add(LiveSessionActivityCancelledEvent());
  });

  test(
      'test bloc emits [LiveSessionProcessingState, LiveSessionFinishedState] after a LiveSessionFinishedEvent is added',
      () async {
    when(mockSaveLiveSessionWithActivities(LiveSessionParams(
            session: testSession, activities: testActivitiesList)))
        .thenAnswer((_) async => Right(1));

    final expected = [
      LiveSessionScreenInitial(),
      LiveSessionProcessingState(),
      LiveSessionFinishedState()
    ];
    expectLater(sut, emitsInOrder(expected));
    sut.add(LiveSessionFinishedEvent());
  });

  // test(
  //     'test for new activity added to activities list after LiveSessionActivityFinishedEvent is added',
  //     () async {
  //   sut.activities.clear();
  //   sut.selectedSkill = testSkill;
  //   await expectLater(
  //       sut.activities[0],
  //       equals(Activity(
  //           skillId: null,
  //           sessionId: null,
  //           date: null,
  //           duration: null,
  //           isComplete: null,
  //           skillString: null)));
  //   sut.add(LiveSessionActivityFinishedEvent(elapsedTime: 30));

  // });
}
