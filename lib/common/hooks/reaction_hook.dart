part of 'hooks.dart';

void useReaction<T>(
  T Function() function,
  void Function(T) effect, {
  List<Object?>? keys,
  bool fireImmediately = false,
  String? name,
  ReactiveContext? context,
  int? delay,
  bool Function(T?, T?)? equals,
  void Function(Object, Reaction)? onError,
}) => use(
  _ReactionHook<T>(
    function: function,
    effect: effect,
    fireImmediately: fireImmediately,
    keys: keys,
    delay: delay,
    context: context,
    equals: equals,
    name: name,
    onError: onError,
  ),
);

class _ReactionHook<T> extends Hook<void> {
  const _ReactionHook({
    required this.function,
    required this.effect,
    required this.fireImmediately,
    this.name,
    this.context,
    this.delay,
    this.equals,
    this.onError,
    super.keys,
  });

  final T Function() function;
  final FutureOr<void> Function(T) effect;
  final bool fireImmediately;
  final String? name;
  final ReactiveContext? context;
  final int? delay;
  final bool Function(T?, T?)? equals;
  final void Function(Object, Reaction)? onError;

  @override
  HookState<void, Hook<void>> createState() => _ReactionHookState<T>();
}

class _ReactionHookState<T> extends HookState<void, _ReactionHook<T>> {
  late ReactionDisposer disposer;

  @override
  void build(BuildContext context) {}

  @override
  void initHook() {
    super.initHook();
    disposer = reaction<T>(
      (_) => hook.function(),
      hook.effect,
      fireImmediately: hook.fireImmediately,
      name: hook.name,
      context: hook.context,
      delay: hook.delay,
      equals: hook.equals,
      onError: hook.onError,
    );
  }

  @override
  void dispose() {
    disposer.call();
    super.dispose();
  }
}
