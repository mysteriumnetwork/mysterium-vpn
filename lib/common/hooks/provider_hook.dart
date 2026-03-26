part of 'hooks.dart';

T useProvider<T>(ProviderListenable<T> provider) => use(_UseProviderHook(provider));

class _UseProviderHook<T> extends Hook<T> {
  const _UseProviderHook(this.provider);

  final ProviderListenable<T> provider;

  @override
  HookState<T, Hook<T>> createState() => _UseProviderHookState<T>();
}

class _UseProviderHookState<T> extends HookState<T, _UseProviderHook<T>> {
  late T _value = ProviderScope.containerOf(context).read(hook.provider);
  ProviderSubscription? _subscription;

  @override
  void initHook() {
    super.initHook();
    _subscription ??= ProviderScope.containerOf(context, listen: false).listen<T>(hook.provider, (
      previous,
      next,
    ) {
      setState(() {
        _value = next;
      });
    });
  }

  @override
  T build(BuildContext context) => _value;

  @override
  String get debugLabel => 'useProvider';

  @override
  void dispose() {
    _subscription?.close();
    _subscription = null;
    super.dispose();
  }
}
