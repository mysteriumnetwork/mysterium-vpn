import 'dart:async';

class ReplayStreamController<T> {
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
    _buffer.add(event);
    _controller.add(event);
  }

  void close() {
    _controller.close();
  }
}
