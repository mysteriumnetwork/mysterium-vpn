import 'package:mobx/mobx.dart';

class ComputedObservableFuture<T, K> extends ObservableFuture<T> {
  ComputedObservableFuture(
    ObservableFuture<K> future, {
    required T Function(K value) transform,
  }) : this._(future, transform: transform);

  ComputedObservableFuture._(
    Future<K> future, {
    required T Function(K value) transform,
  }) : super(future.then(transform));

  static ComputedObservableFuture<T, List<K>> multi<T, K>(
    List<ObservableFuture<K>> futures, {
    required T Function(List<K> values) combine,
  }) =>
      ComputedObservableFuture<T, List<K>>._(
        Future.wait<K>(futures),
        transform: combine,
      );
}
