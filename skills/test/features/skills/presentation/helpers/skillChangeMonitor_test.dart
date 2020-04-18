
import 'package:flutter_test/flutter_test.dart';
import 'package:skills/core/constants.dart';
import 'package:skills/core/enums.dart';
import 'package:skills/features/skills/domain/entities/skill.dart';
import 'package:skills/features/skills/presentation/helpers/skillChangeMonitor.dart';

void main() {
  SkillChangeMonitor sut;
  Skill testSkill;

  setUp(() {
    testSkill = Skill(
      name: 'test',
      source: 'testing',
      startDate: DateTime.utc(2020, 1, 1),
      type: skillTypeToString(SkillType.composition),
      instrument: INSTRUMENTS[0],
      priority: 3,
      proficiency: 5
    );

    sut = SkillChangeMonitor(testSkill);
  });

  group('hasChanged - ', () {
    test(
        'test that hasChanged bool is correct when no values have been changed',
        () {
      
      expect(sut.hasChanged, false);
    });

    test('test that hasChanged bool is correct when a value has been changed',
        () {
      sut.nameText = 'testy';
      expect(sut.hasChanged, true);
    });

    test(
        'test that hasChanged bool is correct when a value has been changed and returned to original value',
        () {
      sut.nameText = 'testy';
      sut.nameText = 'test';
      expect(sut.hasChanged, false);
    });

    test(
        'test that hasChanged bool is correct when multiple values have been changed',
        () {
      sut.nameText = 'testy';
      sut.sourceText = 'testtesting';
      expect(sut.hasChanged, true);
    });

    test(
        'test that hasChanged bool is correct when multiple values have been changed and one has been returned to original',
        () {
      sut.nameText = 'testy';
      sut.sourceText = 'testtesting';
      sut.sourceText = 'testing';
      expect(sut.hasChanged, true);
    });

    test(
        'test that hasChanged bool is correct when all values have been returned to original after being changed',
        () {
      sut.nameText = 'testy';
      sut.sourceText = 'testtesting';
      sut.nameText = 'test';
      sut.sourceText = 'testing';
      expect(sut.hasChanged, false);
    });

    test('test that hasChanged bool is correct when Skill instrument value is changed', (){
      sut.instrumentText = INSTRUMENTS[5];
      expect(sut.hasChanged, true);
    });

    test('test that hasChanged bool is correct when Skill type value is changed', (){
      sut.skillType = skillTypeToString(SkillType.exercise);
      expect(sut.hasChanged, true);
    });

    test('test that hasChanged bool is correct when Skill priority value is changed', (){
      sut.priorityValue = 4;
      expect(sut.hasChanged, true);
    });

    test('test that hasChanged bool is correct when Skill proficiency value is changed', (){
      sut.proficiencyValue = 4;
      expect(sut.hasChanged, true);
    });
  });

  group('toMap - ', () {
    test(
        'test that toMap function returns a correct map when Skill name has been changed',
        () {
      sut.nameText = 'test 1';
      Map<String, dynamic> result = sut.toMap();
      expect(result['name'], equals('test 1'));
    });

    test(
        'test that toMap function returns a correct map when Skill name has been changed, and returned to original value',
        () {
      sut.nameText = 'test 1';
      sut.nameText = 'test';
      Map<String, dynamic> result = sut.toMap();
      expect(result['name'], null);
    });

    test('test that toMap function returns a correct map when Skill instrument has changed', (){
      sut.instrumentText = INSTRUMENTS[3];
      Map<String, dynamic> result = sut.toMap();
      expect(result['instrument'], INSTRUMENTS[3]);
    });

    test('test that toMap function returns a correct map when Skill type has changed', (){
      sut.skillType = skillTypeToString(SkillType.exercise);
      Map<String, dynamic> result = sut.toMap();
      expect(result['type'], skillTypeToString(SkillType.exercise));
    });

    test('test that toMap returns correct map when Skill priority has changed', (){
      sut.priorityValue = 2;
      Map<String, dynamic> result = sut.toMap();
      expect(result['priority'], 2);
    });

    test('test that toMap returns correct map when Skill proficiency has changed', (){
      sut.proficiencyValue = 2;
      Map<String, dynamic> result = sut.toMap();
      expect(result['proficiency'], 2);
    });

  });
}
