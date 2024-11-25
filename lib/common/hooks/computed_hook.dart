import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobx/mobx.dart';

Computed<T> useComputed<T>(T Function() compute, [List<Object> keys = const []]) =>
    use(_ComputedHook(compute, keys));

class _ComputedHook<T> extends Hook<Computed<T>> {
  const _ComputedHook(this.compute, [List<Object> keys = const []]) : super(keys: keys);

  final T Function() compute;

  @override
  HookState<Computed<T>, Hook<Computed<T>>> createState() => _ComputedHookState<T>();
}

class _ComputedHookState<T> extends HookState<Computed<T>, _ComputedHook<T>> {
  late Computed<T> computed;

  @override
  Computed<T> build(BuildContext context) => computed;

  @override
  void initHook() {
    super.initHook();
    computed = Computed(hook.compute);
  }
}
