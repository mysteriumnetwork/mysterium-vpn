import 'dart:async';
import 'dart:io';

class Ping {
  /// Creates a new Ping instance that will measure latency to [host] on [port].
  /// By default, it performs 5 measurements with a timeout of 2 seconds per attempt.
  Ping(String host, int port, {int count = 5, Duration timeout = const Duration(seconds: 2)}) {
    // Launch all ping attempts concurrently
    Future.wait(
      List.generate(count, (_) => _pingOnce(host, port, timeout)),
    ).then(_completer.complete);
  }

  final Completer<List<Duration>> _completer = Completer();

  /// Measures the latency for one TCP connection attempt to [host]:[port].
  /// If the connection cannot be established within [timeout],
  /// it returns a fallback latency value (1000ms).
  Future<Duration> _pingOnce(String host, int port, Duration timeout) async {
    final stopwatch = Stopwatch()..start();
    try {
      final socket = await Socket.connect(host, port, timeout: timeout);
      stopwatch.stop();
      socket.destroy();
      return stopwatch.elapsed;
    } catch (_) {
      stopwatch.stop();
      // Penalize lost packets by returning a high latency value
      return const Duration(milliseconds: 1000);
    }
  }

  /// Returns the median latency measured over the configured number of attempts.
  Future<Duration> latencyMedian() async {
    final responses = await _completer.future;
    responses.sort((a, b) => a.compareTo(b));
    final middle = responses.length ~/ 2;
    if (responses.length.isOdd) {
      return responses[middle];
    } else {
      final medianMs =
          ((responses[middle - 1].inMilliseconds + responses[middle].inMilliseconds) / 2).round();
      return Duration(milliseconds: medianMs);
    }
  }
}
