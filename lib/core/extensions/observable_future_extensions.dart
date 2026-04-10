import 'package:mobx/mobx.dart';

extension ObservableFutureExtensions<T> on ObservableFuture<T> {
  /// Replaces the current future with [nextFuture] if the current future is not rejected.
  /// If the current future is rejected, it creates a new ObservableFuture with [nextFuture].
  /// This is useful to avoid keeping a rejected state when replacing the future.
  /// If you want to always replace the future regardless of its state, use [replace].
  ObservableFuture<T> replaceOrReset(Future<T> nextFuture) {
    if (status == FutureStatus.rejected) {
      return ObservableFuture<T>(nextFuture);
    }
    return replace(nextFuture);
  }
}
