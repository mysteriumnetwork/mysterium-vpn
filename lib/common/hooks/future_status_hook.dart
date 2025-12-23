import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobx/mobx.dart';

(ValueNotifier<Future<T>?> notifier, FutureStatus? status) useFutureStatus<T>() {
  final notifier = useState<Future<T>?>(null);
  final future = useFuture(notifier.value);

  var status = future.connectionState == ConnectionState.waiting ? FutureStatus.pending : null;

  if (future.hasError) {
    status = FutureStatus.rejected;
  }

  if (future.hasData) {
    status = FutureStatus.fulfilled;
  }

  return (notifier, status);
}
