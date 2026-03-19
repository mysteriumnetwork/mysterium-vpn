import 'dart:async';

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
