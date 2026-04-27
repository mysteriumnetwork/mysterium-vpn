import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationsContainer extends StatelessWidget {
  const LocationsContainer({required this.locationType, this.child, this.padding, super.key});

  final EdgeInsets? padding;
  final Widget? child;
  final IPType locationType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.palette.bgSidePanel,
      borderRadius: BorderRadius.only(
        topLeft: locationType == IPType.datacenter ? Radius.kNone : Radius.kS,
        topRight: locationType == IPType.residential ? Radius.kNone : Radius.kS,
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
