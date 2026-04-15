// ignore_for_file: prefer_mixin
import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

abstract final class TrayMenuKeys {
  static const showWindow = 'show_window';
  static const exitApp = 'exit_app';
}

class LifecycleListener extends StatelessWidget {
  const LifecycleListener({
    required this.child,
    this.onResumed,
    this.onPaused,
    this.onInactive,
    this.onDetached,
    this.onHidden,
    this.onThemeChanged,
    super.key,
  });

  final Widget child;
  final VoidCallback? onResumed;
  final VoidCallback? onPaused;
  final VoidCallback? onInactive;
  final VoidCallback? onDetached;
  final VoidCallback? onHidden;
  final VoidCallback? onThemeChanged;

  @override
  Widget build(BuildContext context) => isMobile()
      ? _LifecycleMobile(
          onResumed: onResumed,
          onPaused: onPaused,
          onInactive: onInactive,
          onDetached: onDetached,
          onHidden: onHidden,
          onThemeChanged: onThemeChanged,
          child: child,
        )
      : _LifecycleDesktop(
          onResumed: onResumed,
          onPaused: onPaused,
          onInactive: onInactive,
          onDetached: onDetached,
          onThemeChanged: onThemeChanged,
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
    this.onHidden,
    this.onThemeChanged,
  });

  final Widget child;
  final VoidCallback? onResumed;
  final VoidCallback? onPaused;
  final VoidCallback? onInactive;
  final VoidCallback? onDetached;
  final VoidCallback? onHidden;
  final VoidCallback? onThemeChanged;
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
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    widget.onThemeChanged?.call();
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
      case AppLifecycleState.hidden:
        widget.onHidden?.call();
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
    this.onThemeChanged,
  });

  final Widget child;
  final VoidCallback? onResumed;
  final VoidCallback? onPaused;
  final VoidCallback? onInactive;
  final VoidCallback? onDetached;
  final VoidCallback? onThemeChanged;
  @override
  State<_LifecycleDesktop> createState() => __LifecycleDesktopState();
}

class __LifecycleDesktopState extends State<_LifecycleDesktop>
    with WindowListener, TrayListener, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    trayManager.addListener(this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    widget.onThemeChanged?.call();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> onWindowClose() async {
    if (await windowManager.isPreventClose()) {
      await windowManager.hide();
    } else {
      exit(0);
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
    unawaited(windowManager.show());
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  Future<void> onTrayMenuItemClick(MenuItem menuItem) async {
    switch (menuItem.key) {
      case TrayMenuKeys.showWindow:
        if (!await windowManager.isVisible()) {
          unawaited(windowManager.show());
          trayManager.popUpContextMenu();
        }
      case TrayMenuKeys.exitApp:
        try {
          await getIt<VpnStore>().disposeStore();
          await trayManager.destroy();
        } finally {
          exit(0);
        }
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
