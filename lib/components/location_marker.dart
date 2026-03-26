import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';

class LocationMarker extends StatelessWidget {
  const LocationMarker({
    required this.size,
    required this.isConnected,
    required this.isSelected,
    required this.onPressed,
    this.onDoubleTap,
    super.key,
  });

  final Size size;
  final bool isConnected;
  final bool isSelected;
  final VoidCallback onPressed;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    if (!isConnected && !isSelected) {
      return _Inactive(size: size, onPressed: onPressed, onDoubleTap: onDoubleTap);
    }

    final animation = isConnected ? Asset.animations.pulseGreen : Asset.animations.pulsePurple;

    return _Active(animation: animation, onPressed: onPressed, onDoubleTap: onDoubleTap);
  }
}

class _Inactive extends StatelessWidget {
  const _Inactive({required this.size, required this.onPressed, this.onDoubleTap});

  final Size size;
  final VoidCallback onPressed;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) => _GestureHandler(
    onPressed: onPressed,
    onDoubleTap: onDoubleTap,
    size: size,
    child: DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFE9EAEB).withValues(alpha: .6),
      ),
      child: SizedBox.fromSize(
        size: size,
        child: Center(
          child: DecoratedBox(
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF717680)),
            child: SizedBox.fromSize(size: size * .5),
          ),
        ),
      ),
    ),
  );
}

class _Active extends StatelessWidget {
  const _Active({required this.animation, required this.onPressed, this.onDoubleTap});

  final LottieGenImage animation;
  final VoidCallback onPressed;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) => _GestureHandler(
    onPressed: onPressed,
    onDoubleTap: onDoubleTap,
    size: const Size.square(24),
    child: animation.lottie(repeat: true, fit: BoxFit.contain, alignment: Alignment.center),
  );
}

class _GestureHandler extends StatefulWidget {
  const _GestureHandler({
    required this.onPressed,
    required this.child,
    this.onDoubleTap,
    this.size,
  });

  final Widget child;
  final VoidCallback onPressed;
  final VoidCallback? onDoubleTap;
  final Size? size;

  @override
  State<_GestureHandler> createState() => _GestureHandlerState();
}

class _GestureHandlerState extends State<_GestureHandler> {
  DateTime? _lastTapTime;

  void _handleTap() {
    HapticFeedback.lightImpact();
    final now = DateTime.now();
    if (widget.onDoubleTap != null &&
        _lastTapTime != null &&
        now.difference(_lastTapTime!).inMilliseconds < 300) {
      _lastTapTime = null;
      widget.onDoubleTap!();
    } else {
      _lastTapTime = now;
      widget.onPressed();
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      IgnorePointer(child: Center(child: widget.child)),
      Positioned.fill(
        child: Center(
          child: SizedBox.fromSize(
            size: widget.size,
            child: Material(
              type: MaterialType.transparency,
              shape: const CircleBorder(),
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              child: InkWell(onTap: _handleTap, customBorder: const CircleBorder()),
            ),
          ),
        ),
      ),
    ],
  );
}
