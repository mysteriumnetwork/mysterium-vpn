import 'package:flutter/material.dart';

class ColorFilteredOptional extends StatelessWidget {
  const ColorFilteredOptional({required this.child, required this.colorFilter, super.key});

  final Widget child;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) {
    if (colorFilter == null) {
      return child;
    }
    return ColorFiltered(colorFilter: colorFilter!, child: child);
  }
}
