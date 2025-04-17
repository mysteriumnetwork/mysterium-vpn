import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';

class Banner extends StatelessWidget {
  const Banner({
    required this.title,
    this.cta,
    this.onPressed,
    this.body,
    this.onDismiss,
    this.color = Palette.mediumBlack,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    this.mainBanner = true,
    super.key,
  });

  final Color color;
  final EdgeInsets padding;
  final BorderRadiusGeometry borderRadius;
  final Widget title;
  final Widget? cta;
  final Widget? body;
  final bool mainBanner;

  final VoidCallback? onDismiss;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final canDismiss = onDismiss != null;

    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 0,
      fillColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: const BorderSide(color: Palette.purple, width: 1.5),
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: canDismiss ? 32 : 0),
                    child: title,
                  ),
                  if (body != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: body,
                    ),
                  if (cta != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: cta,
                    ),
                ],
              ),
            ),
          ),
          if (canDismiss)
            Positioned(
              right: 6,
              top: 8,
              child: _DismissButton(
                onPressed: onDismiss,
                mainBanner: mainBanner,
              ),
            ),
        ],
      ),
    );
  }
}

class _DismissButton extends StatelessWidget {
  const _DismissButton({
    required this.onPressed,
    required this.mainBanner,
  });

  final VoidCallback? onPressed;
  final bool mainBanner;

  @override
  Widget build(BuildContext context) => mainBanner
      ? Positioned(
          top: 12,
          right: 12,
          child: Opacity(
            opacity: .4,
            child: IconButton(
              color: Colors.white,
              constraints: BoxConstraints.tight(const Size(32, 32)),
              iconSize: 16,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              style: IconButton.styleFrom(
                backgroundColor: Palette.lightBlack,
              ),
              onPressed: onPressed,
              icon: const Icon(Icons.close_sharp),
            ),
          ),
        )
      : Positioned(
          top: 4,
          right: 4,
          child: IconButton(
            color: Colors.white,
            constraints: BoxConstraints.tight(const Size(24, 24)),
            iconSize: 12,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Palette.lightBlack
                  : Palette.mediumBlack,
            ),
            onPressed: onPressed,
            icon: const Icon(Icons.close_sharp),
          ),
        );
}
