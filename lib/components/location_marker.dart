import 'package:flutter/cupertino.dart';
import 'package:mysterium_vpn/common/styles/style.dart';

class LocationMarker extends StatelessWidget {
  const LocationMarker({
    required this.size,
    this.isActive = false,
    super.key,
  });

  final Size size;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final outerSize = size;
    final innerSize = Size.square(size.longestSide * (isActive ? .5 : .7));

    final borderWidth = isActive ? size.longestSide * .1 : 0.0;
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isActive ? Border.all(color: Palette.purple, width: borderWidth) : null,
        color: Palette.white,
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: Palette.pink.withValues(alpha: .15),
              blurRadius: 4,
              offset: const Offset(2, 4),
            ),
        ],
      ),
      child: SizedBox.fromSize(
        size: outerSize,
        child: Center(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Palette.purple,
            ),
            child: SizedBox.fromSize(size: innerSize),
          ),
        ),
      ),
    );
  }
}
