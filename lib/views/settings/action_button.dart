import 'package:flutter/material.dart';

class SettingActionButton extends StatelessWidget {
  const SettingActionButton({
    required this.action,
    required this.child,
    this.backgroundColor,
    this.height = 34,
    this.width = 100,
    this.borderRadius = 4,
    super.key,
  });

  final Color? backgroundColor;
  final double height;
  final double width;
  final double borderRadius;
  final VoidCallback? action;
  final Widget child;

  @override
  Widget build(BuildContext context) => FilledButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          minimumSize: Size(width, height),
        ),
        onPressed: action,
        child: child,
      );
}
