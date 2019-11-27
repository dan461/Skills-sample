import 'package:skills/core/usecase.dart';
import 'package:skills/features/skills/domain/entities/goal.dart';

class GoalCrudParams extends Params {
  final int id;
  final Goal goal;

  GoalCrudParams({this.id, this.goal}) : super();
}
