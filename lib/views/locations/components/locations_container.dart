import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';

class LocationsContainer extends StatelessWidget {
  const LocationsContainer({
    required this.locationType,
    this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 21),
    super.key,
  });

  final EdgeInsets padding;
  final Widget? child;
  final IPType locationType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.tertiaryContainer,
      borderRadius: BorderRadius.only(
        topLeft: locationType == IPType.datacenter ? Radius.zero : const Radius.circular(12),
        topRight: locationType == IPType.residential ? Radius.zero : const Radius.circular(12),
        bottomLeft: const Radius.circular(12),
        bottomRight: const Radius.circular(12),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
