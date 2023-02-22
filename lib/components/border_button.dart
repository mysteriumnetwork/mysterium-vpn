// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:

class BorderButton extends StatelessWidget {
  const BorderButton({
    required this.child,
    required this.onPressed,
    super.key,
    this.color,
    this.width,
  });

  final Widget child;
  final VoidCallback onPressed;
  final Color? color;
  final double? width;
  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onPressed,
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              side: MaterialStateProperty.all<BorderSide>(
                BorderSide(color: color ?? Palette.black, width: 1.5),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
        child: child,
      ).width(width ?? double.infinity);
}
