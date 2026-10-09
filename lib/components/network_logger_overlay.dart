import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/debug/network_logger/network_logger_view.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class NetworkLoggerOverlayView extends StatefulHookConsumerWidget {
  const NetworkLoggerOverlayView({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<NetworkLoggerOverlayView> createState() => _NetworkLoggerOverlayViewState();
}

class _NetworkLoggerOverlayViewState extends ConsumerState<NetworkLoggerOverlayView> {
  final _loggerNavigatorKey = GlobalKey<NavigatorState>();
  late final _loggerObservers = <NavigatorObserver>[
    _CloseOnLastPop(() => _setLoggerOpen(open: false)),
  ];
  double _xPosition = 0;
  double _yPosition = 0;
  bool _loggerOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _xPosition = MediaQuery.of(context).size.width - 64;
    _yPosition = MediaQuery.of(context).size.height - 128;
  }

  void _setLoggerOpen({required bool open}) {
    if (mounted && _loggerOpen != open) {
      setState(() => _loggerOpen = open);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(remoteConfigStorePOD);
    final enableQAHelpers = useComputedValue(() => store.enableQaHelpers);
    final shouldShowLogger = !kReleaseMode || enableQAHelpers;

    if (!shouldShowLogger) {
      // Flag flipped off mid-session; don't re-open on the way back.
      _loggerOpen = false;
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        // Own navigator, sibling of `child` so `Navigator.of` still finds the app router.
        if (_loggerOpen)
          Positioned.fill(
            // Not PopScope: no ModalRoute here, so it would silently no-op.
            child: BackButtonListener(
              onBackButtonPressed: () async {
                final navigator = _loggerNavigatorKey.currentState;
                if (navigator != null && navigator.canPop()) {
                  navigator.pop();
                } else {
                  _setLoggerOpen(open: false);
                }
                return true;
              },
              child: Navigator(
                key: _loggerNavigatorKey,
                observers: _loggerObservers,
                onGenerateRoute: (settings) => MaterialPageRoute<void>(
                  settings: settings,
                  builder: (_) => NetworkLoggerScreen(),
                ),
              ),
            ),
          ),
        if (!_loggerOpen && _xPosition != 0 && _yPosition != 0)
          Positioned(
            top: _yPosition,
            left: _xPosition,
            child: GestureDetector(
              onPanUpdate: (tapInfo) {
                if (mounted) {
                  setState(() {
                    _xPosition += tapInfo.delta.dx;
                    _yPosition += tapInfo.delta.dy;
                  });
                }
              },
              child: NetworkLoggerButton(
                color: Palette.brand,
                onPressed: () => _setLoggerOpen(open: true),
              ),
            ),
          ),
      ],
    );
  }
}

/// Closes the host once the logger's own root route is popped.
class _CloseOnLastPop extends NavigatorObserver {
  _CloseOnLastPop(this._onEmpty);

  final VoidCallback _onEmpty;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute == null) {
      // Pops land mid-frame, so defer the setState out of the build phase.
      scheduleMicrotask(_onEmpty);
    }
  }
}
