import 'package:skills/features/skills/domain/entities/skill.dart';

class SkillChangeMonitor {
  final Skill skill;

  String nameText;
  String sourceText;
  String skillType;
  String instrumentText;
  int priorityValue;
  double proficiencyValue;

  SkillChangeMonitor(this.skill) {
    if (skill != null) {
      nameText = skill.name;
      sourceText = skill.source;
      instrumentText = skill.instrument;
      skillType = skill.type;
      priorityValue = skill.priority;
      proficiencyValue = skill.proficiency;
    }
  }

  bool get hasChanged {
    if (nameText != skill.name ||
        sourceText != skill.source ||
        instrumentText != skill.instrument ||
        skillType != skill.type ||
        priorityValue != skill.priority ||
        proficiencyValue != skill.proficiency)
      return true;
    else
      return false;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    if (nameText != skill.name) {
      map['name'] = nameText;
    }

    if (sourceText != skill.source) {
      map['source'] = sourceText;
    }

    if (instrumentText != skill.instrument) {
      map['instrument'] = instrumentText;
    }

    if (skillType != skill.type) {
      map['type'] = skillType;
    }

    if (priorityValue != skill.priority) {
      map['priority'] = priorityValue;
    }

    if (proficiencyValue != skill.proficiency) {
      map['proficiency'] = proficiencyValue;
    }

    return map;
  }
}
