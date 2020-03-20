import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/error/failures.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/domain/entities/session.dart';
import 'package:skills/features/skills/domain/usecases/usecaseParams.dart';
import 'package:skills/features/skills/presentation/bloc/activeSessionScreen/activesession_bloc.dart';
import '../../mockClasses.dart';

void main() {
  ActiveSessionBloc sut;
  Session testSession;
  List<Map> testMaps;
  Activity testActivity;
  Map<String, dynamic> activityMap;

  setUp(() {
    sut = ActiveSessionBloc();
    testSession = Session(
        sessionId: 1,
        date: DateTime.now(),
        startTime: TimeOfDay(hour: 12, minute: 0),
        duration: 30,
        isComplete: false,
        isScheduled: true);

    testActivity = Activity(
        skillId: 1,
        sessionId: 1,
        duration: 10,
        date: DateTime.fromMillisecondsSinceEpoch(0),
        isComplete: false,
        skillString: 'test');
    activityMap = {'activity': testActivity};
    testMaps = [activityMap];
  });

  test('test for correct initial state', () {
    expect(sut.initialState, equals(ActiveSessionInitial()));
  });

  test(
      'test for bloc emitting [ActiveSessionInfoLoadedState] after ActiveSessionLoadInfoEvent added',
      () async {
    sut.add(ActiveSessionLoadInfoEvent(
        session: testSession, activityMaps: testMaps));
    final expected = [
      ActiveSessionInitial(),
      ActiveSessionInfoLoadedState(
          activityMaps: testMaps, duration: testSession.duration)
    ];
    expectLater(sut, emitsInOrder(expected));
  });

  test(
      'test for bloc emitting [ActivityReadyState] after ActivitySelectedForTimerEvent is added.',
      () async {
    sut.add(ActivitySelectedForTimerEvent(selectedMap: activityMap));
    final expected = [
      ActiveSessionInitial(),
      ActivityReadyState(activity: activityMap['activity'])
    ];
    expectLater(sut, emitsInOrder(expected));
  });

  // test(
  //     'test for correct activity map selected after ActivitySelectedForTimerEvent is added',
  //     () async {
  //   sut.add(ActivitySelectedForTimerEvent(selectedMap: activityMap));
  //   expectLater(sut.selectedMap, equals(activityMap));
  // });

  test(
      'test for bloc emitting [ActivityTimerStoppedState] after ActivityTimerStoppedEvent is added.',
      () async {
    sut.add(ActivityTimerStoppedEvent());
    final expected = [ActiveSessionInitial(), ActivityTimerStoppedState()];
    expectLater(sut, emitsInOrder(expected));
  });

  // CurrentActivityFinishedState
  test(
      'test for bloc emitting [CurrentActivityFinishedState] after CurrentActivityFinishedEvent is added.',
      () async {
    sut.add(CurrentActivityFinishedEvent(time: 20));
    final expected = [ActiveSessionInitial(), CurrentActivityFinishedState()];
    expectLater(sut, emitsInOrder(expected));
  });
}
