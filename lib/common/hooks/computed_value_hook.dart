part of 'hooks.dart';

T useComputedValue<T>(T Function() compute, [List<Object?> keys = const []]) =>
    use(_ComputedValueHook(compute, keys));

class _ComputedValueHook<T> extends Hook<T> {
  const _ComputedValueHook(this.compute, [List<Object?> keys = const []]) : super(keys: keys);
  final T Function() compute;

  @override
  _ComputedValueHookState<T> createState() => _ComputedValueHookState<T>();
}

class _ComputedValueHookState<T> extends HookState<T, _ComputedValueHook<T>> {
  late Computed<T> computed;
  late T value;
  late ReactionDisposer disposer;

  @override
  void initHook() {
    super.initHook();
    computed = Computed(hook.compute);
    value = computed.value;
    disposer = autorun((_) {
      setState(() {
        value = computed.value;
      });
    });
  }

  @override
  void dispose() {
    disposer();
    super.dispose();
  }

  @override
  T build(BuildContext context) => value;
}
