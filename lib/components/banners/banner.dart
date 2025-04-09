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
    super.key,
  });

  final Color color;
  final EdgeInsets padding;
  final BorderRadiusGeometry borderRadius;
  final Widget title;
  final Widget? cta;
  final Widget? body;

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
          if (canDismiss)
            Positioned(
              top: 2,
              right: 4,
              child: _DismissButton(onPressed: onDismiss),
            ),
          Center(
            child: Padding(
              padding: padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: canDismiss ? 32 : 0),
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
        ],
      ),
    );
  }
}

class _DismissButton extends StatelessWidget {
  const _DismissButton({
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Opacity(
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
      );
}
