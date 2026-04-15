import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/services/services.dart';

class NetworkLoggerOverlayView extends StatefulWidget {
  const NetworkLoggerOverlayView({required this.child, super.key});

  final Widget child;

  @override
  State<NetworkLoggerOverlayView> createState() => _NetworkLoggerOverlayViewState();
}

class _NetworkLoggerOverlayViewState extends State<NetworkLoggerOverlayView> {
  final _store = getIt<RemoteConfigStore>();
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
  Widget build(BuildContext context) => Observer(
      builder: (context) {
        final enableQAHelpers = _store.enableQaHelpers;
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
      },
    );
}
