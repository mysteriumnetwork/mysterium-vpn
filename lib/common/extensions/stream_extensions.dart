import 'dart:async';

import 'package:talker/talker.dart';

extension StreamExtensions<T> on Stream<T> {
  Stream<T> doOnListen(
    FutureOr<void> Function() onListen, {
    Function(Object, StackTrace)? onError,
  }) => Stream<T>.eventTransformed(this, (sink) {
    Future<void> handleOnListen() async {
      try {
        await onListen();
      } catch (e, stack) {
        if (onError != null) {
          onError(e, stack);
        } else {
          sink.addError(e, stack);
        }
      }
    }

    handleOnListen();
    return sink;
  });
}

extension SafeStreamListen<T> on Stream<T> {
  /// [listen] that reports failures instead of letting them escape.
  ///
  /// Guards both halves: errors the stream emits, and errors thrown by
  /// [onData] — including an async body, whose future `listen` discards. An
  /// unguarded one becomes an unhandled async error, and on Android the UI
  /// isolate is the main thread, so reporting it runs there.
  StreamSubscription<T> listenSafely(
    FutureOr<void> Function(T event) onData, {
    required Talker logger,
    required String context,
  }) => listen((event) async {
    try {
      await onData(event);
    } catch (e, stack) {
      logger.warning('$context failed', e, stack);
    }
  }, onError: (Object e, StackTrace stack) => logger.warning('$context stream failed', e, stack));
}
