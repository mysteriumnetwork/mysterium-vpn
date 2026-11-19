import 'dart:async';

class ReplayStreamController<T> {
  ReplayStreamController({this.maxBufferedEvents = 500});

  /// The buffer only feeds the QA log overlay, so it is capped: analytics and
  /// error reporting append to it for the life of the process, and an
  /// unbounded list there is retained garbage on the reporting path.
  final int maxBufferedEvents;

  final _buffer = <T>[];
  final _controller = StreamController<T>.broadcast();

  Stream<T> get stream async* {
    // Emit all buffered events first
    for (final event in _buffer) {
      yield event;
    }
    // Then emit new events
    yield* _controller.stream;
  }

  void add(T event) {
    if (_buffer.length >= maxBufferedEvents) {
      _buffer.removeAt(0);
    }
    _buffer.add(event);
    _controller.add(event);
  }

  void close() {
    _controller.close();
  }
}
