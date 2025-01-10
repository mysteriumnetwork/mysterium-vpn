import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef Result<T extends RenderObject> = ({GlobalKey key, T? value});

Result<T> useRenderObject<T extends RenderObject>() => use(_RenderObjectHook<T>());

class _RenderObjectHook<T extends RenderObject> extends Hook<Result<T>> {
  const _RenderObjectHook();

  @override
  HookState<Result<T>, Hook<Result<T>>> createState() => _RenderObjectHookState<T>();
}

class _RenderObjectHookState<T extends RenderObject>
    extends HookState<Result<T>, _RenderObjectHook<T>> {
  final key = GlobalKey();
  T? _value;

  @override
  void initHook() {
    super.initHook();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = key.currentContext;
      final object = context?.findRenderObject();
      if (object is T) {
        setState(() {
          _value = object;
        });
      }
    });
  }

  @override
  Result<T> build(BuildContext context) => (key: key, value: _value);
}
