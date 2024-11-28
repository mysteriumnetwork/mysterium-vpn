part of 'hooks.dart';

void useReaction<T>(
  T Function() function,
  void Function(T) effect, [
  List<Object?>? keys,
]) =>
    use(_ReactionHook<T>(function: function, effect: effect, keys: keys));

class _ReactionHook<T> extends Hook<void> {
  const _ReactionHook({
    required this.function,
    required this.effect,
    super.keys,
  });

  final T Function() function;
  final FutureOr<void> Function(T) effect;

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
    disposer = reaction<T>((_) => hook.function(), hook.effect);
  }

  @override
  void dispose() {
    disposer.call();
    super.dispose();
  }
}
