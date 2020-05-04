import 'package:flutter_test/flutter_test.dart';
import 'package:skills/features/skills/presentation/helpers/stopwatchTimer.dart';

void main() {
  StopwatchTimer sut;

  setUp(() {
    sut = StopwatchTimer();
  });

  test('test that isRunning bool returns correct value when timer is running',
      () {
    sut.start();
    expect(sut.isRunning, true);
  });

  test(
      'test that isRunning bool returns correct value when timer is not running',
      () {
    sut.start();
    sut.stop();
    expect(sut.isRunning, false);
  });

  test('test that elapsedSeconds value is 0 after reset() called', () {
    sut.start();
    sut.reset();
    expect(sut.elapsedSeconds, equals(0));
  });
}
