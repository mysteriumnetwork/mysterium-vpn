import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

(ValueNotifier<Future<T>?> notifier, AsyncSnapshot<T> status) useFutureStatus<T>() {
  final notifier = useState<Future<T>?>(null);
  final future = useFuture(notifier.value);

  return (notifier, future);
}

extension ValueNotifierFutureExtension<T> on ValueNotifier<Future<T>?> {
  void run(Future<T> Function() futureBuilder) {
    final future = futureBuilder();
    value = future;
  }

  Future<void> runAndAwait(Future<T> Function() futureBuilder) async {
    final future = futureBuilder();
    value = future;
    await future;
  }
}

extension AsyncSnapshotExtension<T> on AsyncSnapshot<T> {
  bool get isLoading => connectionState == ConnectionState.waiting;
}
