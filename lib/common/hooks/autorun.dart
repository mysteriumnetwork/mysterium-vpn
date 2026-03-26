part of 'hooks.dart';

typedef AutorunFunction = void Function();

void useAutorun(AutorunFunction fn, [List<Object?>? keys]) => use(_AutorunHook(fn, keys));

class _AutorunHook extends Hook<void> {
  const _AutorunHook(this.fn, [List<Object?>? keys]) : super(keys: keys);
  final VoidCallback fn;

  @override
  HookState<void, Hook<void>> createState() => _AutorunHookState();
}

class _AutorunHookState extends HookState<void, _AutorunHook> {
  ReactionDisposer? disposer;

  @override
  void build(BuildContext context) {}

  @override
  void initHook() {
    super.initHook();
    scheduleAutorun();
  }

  void scheduleAutorun() {
    disposer = autorun((_) => hook.fn());
  }

  @override
  void dispose() {
    if (disposer != null) {
      disposer?.call();
    }
  }

  @override
  bool get debugSkipValue => true;

  @override
  String get debugLabel => 'useAutorun';
}
