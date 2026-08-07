import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationsContainer extends StatelessWidget {
  const LocationsContainer({
    required this.flattenTopLeft,
    required this.flattenTopRight,
    this.child,
    this.padding,
    super.key,
  });

  final EdgeInsets? padding;
  final Widget? child;

  /// Flatten the corner under the active tab when it sits at that edge.
  final bool flattenTopLeft;
  final bool flattenTopRight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.palette.bgSidePanel,
      borderRadius: BorderRadius.only(
        topLeft: flattenTopLeft ? Radius.kNone : Radius.kS,
        topRight: flattenTopRight ? Radius.kNone : Radius.kS,
        bottomLeft: Radius.kM,
        bottomRight: Radius.kM,
      ),
      child: Padding(
        padding:
            padding ??
            EdgeInsets.symmetric(horizontal: theme.spacing.md, vertical: theme.spacing.xl),
        child: child,
      ),
    );
  }
}
