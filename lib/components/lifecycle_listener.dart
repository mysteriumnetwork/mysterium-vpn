import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class LifecycleListener extends StatelessWidget {
  const LifecycleListener({
    required this.child,
    this.onResumed,
    this.onPaused,
    this.onInactive,
    this.onDetached,
    super.key,
  });

  final Widget child;
  final VoidCallback? onResumed;
  final VoidCallback? onPaused;
  final VoidCallback? onInactive;
  final VoidCallback? onDetached;

  @override
  Widget build(BuildContext context) => isMobile()
      ? _LifecycleMobile(
          onResumed: onResumed,
          onPaused: onPaused,
          onInactive: onInactive,
          onDetached: onDetached,
          child: child,
        )
      : _LifecycleDesktop(
          onResumed: onResumed,
          onPaused: onPaused,
          onInactive: onInactive,
          onDetached: onDetached,
          child: child,
        );
}

class _LifecycleMobile extends StatefulWidget {
  const _LifecycleMobile({
    required this.child,
    this.onResumed,
    this.onPaused,
    this.onInactive,
    this.onDetached,
  });

  final Widget child;
  final VoidCallback? onResumed;
  final VoidCallback? onPaused;
  final VoidCallback? onInactive;
  final VoidCallback? onDetached;

  @override
  State<_LifecycleMobile> createState() => __LifecycleMobileState();
}

class __LifecycleMobileState extends State<_LifecycleMobile> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        widget.onResumed?.call();
        break;
      case AppLifecycleState.paused:
        widget.onPaused?.call();
        break;
      case AppLifecycleState.inactive:
        widget.onInactive?.call();
        break;
      case AppLifecycleState.detached:
        widget.onDetached?.call();
        break;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _LifecycleDesktop extends StatefulWidget {
  const _LifecycleDesktop({
    required this.child,
    this.onResumed,
    this.onPaused,
    this.onInactive,
    this.onDetached,
  });

  final Widget child;
  final VoidCallback? onResumed;
  final VoidCallback? onPaused;
  final VoidCallback? onInactive;
  final VoidCallback? onDetached;

  @override
  State<_LifecycleDesktop> createState() => __LifecycleDesktopState();
}

// ignore: prefer_mixin
class __LifecycleDesktopState extends State<_LifecycleDesktop> with WindowListener, TrayListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    trayManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  Future<void> onWindowClose() async {
    if (await windowManager.isPreventClose()) {
      await windowManager.hide();
    } else {
      windowManager.destroy();
    }
  }

  @override
  void onWindowFocus() {
    widget.onResumed?.call();
  }

  @override
  void onWindowRestore() {
    widget.onResumed?.call();
  }

  @override
  Future<void> onTrayIconMouseDown() async {
    if (!await windowManager.isVisible()) {
      windowManager.show();
    }
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  Future<void> onTrayMenuItemClick(MenuItem menuItem) async {
    if (menuItem.key == 'show_window') {
      if (!await windowManager.isVisible()) {
        windowManager.show();
        trayManager.popUpContextMenu();
      }
    } else if (menuItem.key == 'exit_app') {
      trayManager.destroy();
      windowManager.destroy();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
