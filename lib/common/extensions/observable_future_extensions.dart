import 'package:mobx/mobx.dart';

extension ObservableFutureExtensions<T> on ObservableFuture<T> {
  ObservableFuture<T> replaceOrReset(Future<T> nextFuture) {
    if (status == FutureStatus.rejected) {
      return ObservableFuture<T>(nextFuture);
    }
    return replace(nextFuture);
  }
}
