import 'dart:async';

class StopwatchTimer {
  Timer _timer;
  int elapsedSeconds = 0;
  Function tickCallback;

  StopwatchTimer();

  bool get isRunning {
    return _timer != null && _timer.isActive;
  }

  void _tick(Timer _timer) {
    tickCallback();
    ++elapsedSeconds;
  }

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void stop() {
    if (isRunning) {
      _timer.cancel();
    }
  }

  void reset() {
    stop();
    elapsedSeconds = 0;
  }

  void cancel(){
    _timer.cancel();
    // elapsedSeconds = 0;
  }
}
