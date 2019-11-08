import 'package:skills/features/skills/data/models/skillModel.dart';

abstract class SkillsRemoteDataSource {
  // Throws [ServerException]
  Future<List<SkillModel>> downloadAllSkills();
}