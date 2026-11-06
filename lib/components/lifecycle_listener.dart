// ignore_for_file: prefer_mixin
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
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

class __LifecycleDesktopState extends ConsumerState<_LifecycleDesktop> with WidgetsBindingObserver {
  Window? _window;
  ListenerId? _windowListenerId;

  @override
  void initState() {
    super.initState();
    _window = mainWindow;
    _windowListenerId = _window?.addListener(_onWindowEvent);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    widget.onThemeChanged?.call();
  }

  @override
  void dispose() {
    final listenerId = _windowListenerId;
    if (listenerId != null) {
      _window?.removeListener(listenerId);
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Closing only hides; the tray menu's Exit is the one real way out.
  void _onWindowEvent(WindowEvent event) {
    if (event is WindowCloseRequestedEvent) {
      event.request.cancel();
      _window?.hide();
      _setFocused(false);
    } else if (event is WindowFocusedEvent || event is WindowRestoredEvent) {
      widget.onResumed?.call();
      _setFocused(true);
    } else if (event is WindowBlurredEvent ||
        event is WindowMinimizedEvent ||
        event is WindowClosedEvent) {
      _setFocused(false);
    }
  }

  void _setFocused(bool focused) {
    if (!mounted) {
      return;
    }
    ref.read(isAppWindowFocused.notifier).focused = focused;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
