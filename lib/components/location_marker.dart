import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';

class LocationMarker extends StatelessWidget {
  const LocationMarker({
    required this.size,
    required this.isConnected,
    required this.isSelected,
    required this.onPressed,
    super.key,
  });

  final Size size;
  final bool isConnected;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (!isConnected && !isSelected) {
      return _Inactive(size: size, onPressed: onPressed);
    }

    final color = isConnected ? Palette.forestGreen : Palette.purple;
    final animation = isConnected ? Asset.animations.pulseGreen : Asset.animations.pulsePurple;

    return _Active(
      animation: animation,
      color: color,
      size: size * 5,
    );
  }
}

class _Inactive extends StatelessWidget {
  const _Inactive({
    required this.size,
    required this.onPressed,
  });

  final Size size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => _GestureHandler(
        onPressed: onPressed,
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
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF717680),
                ),
                child: SizedBox.fromSize(size: size * .5),
              ),
            ),
          ),
        ),
      );
}

class _Active extends StatelessWidget {
  const _Active({
    required this.animation,
    required this.color,
    required this.size,
  });

  final LottieGenImage animation;
  final Color color;
  final Size size;

  @override
  Widget build(BuildContext context) => animation.lottie(
        repeat: true,
        fit: BoxFit.contain,
        alignment: Alignment.center,
      );
}

class _GestureHandler extends StatelessWidget {
  const _GestureHandler({
    required this.onPressed,
    required this.child,
    this.size,
  });

  final Widget child;
  final VoidCallback onPressed;
  final Size? size;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          IgnorePointer(child: Center(child: child)),
          Positioned.fill(
            child: Center(
              child: SizedBox.fromSize(
                size: size,
                child: Material(
                  type: MaterialType.transparency,
                  shape: const CircleBorder(),
                  color: Colors.transparent,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onPressed();
                    },
                    customBorder: const CircleBorder(),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
