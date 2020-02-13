enum SkillType { composition, exercise }
String skillTypeToString(SkillType type) {
  return type.toString().split('.').last;
}
