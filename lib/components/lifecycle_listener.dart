// ignore_for_file: prefer_mixin
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

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

class _LifecycleDesktop extends ConsumerStatefulWidget {
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
  ConsumerState<_LifecycleDesktop> createState() => __LifecycleDesktopState();
}

class __LifecycleDesktopState extends ConsumerState<_LifecycleDesktop>
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
    windowManager.show();
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
      ref.read(vpnStorePOD).disposeStore().whenComplete(() async {
        await trayManager.destroy();
        exit(0);
      });
    }
  }

  @override
  void onWindowEvent(String eventType) {
    if (eventType == 'closed' || eventType == 'minimized' || eventType == 'blur') {
      ref.read(isAppWindowFocused.notifier).focused = false;
    }
    if (eventType == 'restored' || eventType == 'focus') {
      ref.read(isAppWindowFocused.notifier).focused = true;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
