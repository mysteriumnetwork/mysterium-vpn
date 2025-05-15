import 'dart:async';

import 'package:dart_ping/dart_ping.dart' as dart_ping;

class Ping {
  Ping(String host) : _ping = dart_ping.Ping(host, count: 5) {
    final responses = <dart_ping.PingData>[];
    _subscription = _ping.stream.listen((response) {
      responses.add(response);

      if (responses.length == 5) {
        _subscription.cancel();
        _completer.complete(responses);
      }
    });
  }

  final dart_ping.Ping _ping;
  late final StreamSubscription<dart_ping.PingData> _subscription;
  final Completer<List<dart_ping.PingData>> _completer = Completer();

  Future<Duration> latencyMedian() async {
    final responses = await _completer.future;

    final latencies = List<Duration>.empty(growable: true);
    for (final response in responses) {
      final ttl = response.response?.time;
      if (ttl != null) {
        latencies.add(ttl);
      } else {
        latencies.add(const Duration(milliseconds: 1000));
      }
      continue;
    }

    latencies.sort();
    final middle = latencies.length ~/ 2;
    if (latencies.length.isOdd) {
      return latencies[middle];
    } else {
      return (latencies[middle - 1] + latencies[middle]) ~/ 2;
    }
  }
}
