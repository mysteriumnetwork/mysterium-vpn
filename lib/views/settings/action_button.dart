import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    required this.action,
    required this.child,
    this.backgroundColor = Palette.purple,
    this.buttonHeight = 34,
    this.buttonWidth = 100,
    this.buttonBorderRadius = 4,
    super.key,
  });

  final Color backgroundColor;
  final double buttonHeight;
  final double buttonWidth;
  final double buttonBorderRadius;
  final VoidCallback? action;
  final Widget child;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius),
          ),
          minimumSize: const Size(100, 38),
        ),
        onPressed: action,
        child: child,
      );
}
