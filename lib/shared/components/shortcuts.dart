import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

class ShortcutsWidget extends StatelessWidget {
  const ShortcutsWidget({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Shortcuts(
    shortcuts: const <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.keyW, meta: true): MinimizeIntent(),
    },
    child: Actions(
      actions: <Type, Action<Intent>>{
        MinimizeIntent: CallbackAction<MinimizeIntent>(
          onInvoke: (MinimizeIntent intent) => windowManager.minimize(),
        ),
      },
      child: child,
    ),
  );
}

class MinimizeIntent extends Intent {
  const MinimizeIntent();
}
