/// Lets an error through once per [window], so a looping failure cannot pin the
/// main thread in the reporting pipeline.
class ErrorReportThrottle {
  ErrorReportThrottle({this.window = const Duration(seconds: 30), this.maxTrackedErrors = 64});

  final Duration window;
  final int maxTrackedErrors;

  /// Insertion-ordered, and re-inserted on every hit so the first key is the
  /// least recently *seen*. Ordering by last report instead would evict the
  /// hot, still-looping error — the one the throttle exists to hold back.
  final Map<String, DateTime> _lastReported = {};

  bool allow(Object? error) {
    final key = _keyFor(error);
    final now = DateTime.now();
    final last = _lastReported.remove(key);
    if (last != null && now.difference(last) < window) {
      // Keep the original timestamp, or the window would never elapse.
      _lastReported[key] = last;
      return false;
    }
    if (_lastReported.length >= maxTrackedErrors) {
      _lastReported.remove(_lastReported.keys.first);
    }
    _lastReported[key] = now;
    return true;
  }

  String _keyFor(Object? error) {
    final text = error.toString();
    return '${error.runtimeType}:${text.length <= 200 ? text : text.substring(0, 200)}';
  }
}
