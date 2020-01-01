import 'package:flutter_test/flutter_test.dart';
import 'package:skills/core/aboutTime.dart';

void main() {
  group('changeMonth', () {
    test('test that month is correct after change of 0', () async {
      var startMonth = DateTime(2020, 1);
      var matcher = DateTime(2020, 1);
      var newMonth = AboutTime.changeMonth(startMonth, 0);
      expect(newMonth, matcher);
    });

    test('test that month is correct after change of 1', () async {
      var startMonth = DateTime(2020, 1);
      var matcher = DateTime(2020, 2);
      var newMonth = AboutTime.changeMonth(startMonth, 1);
      expect(newMonth, matcher);
    });

    test('test that month is correct after change of -1', () async {
      var startMonth = DateTime(2020, 1);
      var matcher = DateTime(2019, 12);
      var newMonth = AboutTime.changeMonth(startMonth, -1);
      expect(newMonth, matcher);
    });
  });
}
