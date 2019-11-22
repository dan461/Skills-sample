import 'package:skills/core/error/failures.dart' show CacheFailure;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';
import 'package:skills/features/skills/presentation/bloc/goalEditorScreen/bloc.dart';

void main() {
  GoaleditorBloc sut;
  Goal testTaskGoal;

  setUp(() {
    sut = GoaleditorBloc();
  });

  group('testing translation of a goal to a descriptive string', () {
    test(
        'test translation of a time based goal into a descriptive string, with hours and minutes.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 04);

      final testTimeGoal = Goal(
          fromDate: from.millisecondsSinceEpoch,
          toDate: to.millisecondsSinceEpoch,
          timeBased: true,
          goalTime: 330);

      String matcher = "Goal: 5 hrs 30 min between Jul 2 and Jul 4.";
      String translation = sut.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });

    test(
        'test translation of a time based goal into a descriptive string, with one hour and no minutes.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 04);

      final testTimeGoal = Goal(
          fromDate: from.millisecondsSinceEpoch,
          toDate: to.millisecondsSinceEpoch,
          timeBased: true,
          goalTime: 60);

      String matcher = "Goal: 1 hour between Jul 2 and Jul 4.";
      String translation = sut.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });

    test(
        'test translation of a time based goal into a descriptive string, with less that one hour.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 04);

      final testTimeGoal = Goal(
          fromDate: from.millisecondsSinceEpoch,
          toDate: to.millisecondsSinceEpoch,
          timeBased: true,
          goalTime: 15);

      String matcher = "Goal: 15 minutes between Jul 2 and Jul 4.";
      String translation = sut.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });

    test(
        'test translation of a time based goal into a descriptive string, start and end on same day.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 02);

      final testTimeGoal = Goal(
          fromDate: from.millisecondsSinceEpoch,
          toDate: to.millisecondsSinceEpoch,
          timeBased: true,
          goalTime: 90);

      String matcher = "Goal: 1 hrs 30 min on Jul 2.";
      String translation = sut.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });

    test(
        'test translation of a task based goal into a descriptive string, start and end on different days.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 04);

      final testTimeGoal = Goal(
          fromDate: from.millisecondsSinceEpoch,
          toDate: to.millisecondsSinceEpoch,
          timeBased: false,
          goalTime: 0,
          desc: 'Practice practice practice');

      String matcher = "Goal: Practice practice practice between Jul 2 and Jul 4.";
      String translation = sut.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });

    test(
        'test translation of a task based goal into a descriptive string, start and end on same day.',
        () {
      DateTime from = DateTime(2019, 07, 02);
      DateTime to = DateTime(2019, 07, 02);

      final testTimeGoal = Goal(
          fromDate: from.millisecondsSinceEpoch,
          toDate: to.millisecondsSinceEpoch,
          timeBased: false,
          goalTime: 0,
          desc: 'Practice practice practice');

      String matcher = "Goal: Practice practice practice on Jul 2.";
      String translation = sut.translateGoal(testTimeGoal);

      expect(translation, matcher);
    });
  });
}
