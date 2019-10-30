import 'package:skills/features/skills/data/models/skillModel.dart';

abstract class SkillsLocalDataSource {
  // Throws [CacheException]
  Future<List<SkillModel>> getAllSkills();
  Future<SkillModel> getSkillById(int id);
  Future<int> insertNewSkill(SkillModel skillModel);
}
