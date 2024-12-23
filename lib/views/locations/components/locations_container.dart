import 'package:flutter/material.dart';

class LocationsContainer extends StatelessWidget {
  const LocationsContainer({
    this.child,
    this.borderRadius = const BorderRadius.vertical(bottom: Radius.circular(12)),
    this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 21),
    super.key,
  });

  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: borderRadius,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
