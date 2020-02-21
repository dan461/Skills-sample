enum SkillType { composition, exercise }
String skillTypeToString(SkillType type) {
  return type.toString().split('.').last;
}

enum SkillPriority {
  lowest,
  low,
  normal,
  high,
  highest
}