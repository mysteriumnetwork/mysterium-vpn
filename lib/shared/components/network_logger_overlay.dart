import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/services.dart';

class NetworkLoggerOverlayView extends StatefulHookConsumerWidget {
  const NetworkLoggerOverlayView({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<NetworkLoggerOverlayView> createState() => _NetworkLoggerOverlayViewState();
}

class _NetworkLoggerOverlayViewState extends ConsumerState<NetworkLoggerOverlayView> {
  double _xPosition = 0;
  double _yPosition = 0;

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

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(remoteConfigStorePOD);
    final enableQAHelpers = useComputedValue(() => store.enableQaHelpers);
    final shouldShowLogger = !kReleaseMode || enableQAHelpers;

    if (shouldShowLogger) {
      return Stack(
        children: [
          widget.child,
          if (_xPosition != 0 && _yPosition != 0) ...[
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
                  color: Palette.purple,
                  globalNavKey: Beamer.of(context).navigatorKey,
                ),
              ),
            ),
          ],
        ],
      );
    } else {
      return widget.child;
    }
  }
}
