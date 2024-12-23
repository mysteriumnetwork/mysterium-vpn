import 'dart:async';

class Debouncer {
  Timer? _timer;

  void debounce(
    FutureOr<void> Function() fnc, [
    Duration duration = const Duration(milliseconds: 500),
  ]) {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
      _timer = null;
    }
    _timer = Timer(duration, fnc);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
