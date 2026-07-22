import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Empty-state shown inside the locations list when the search query returns
/// nothing: concentric "radar" rings around the search glyph, the explanatory
/// copy, and a [ButtonSecondary] to clear the query.
///
/// See [RadarEmptyState] for how [availableHeight] adapts the top padding to the
/// viewport's remaining space.
class LocationsEmptySearchResult extends StatelessWidget {
  const LocationsEmptySearchResult({required this.onClear, this.availableHeight, super.key});

  final VoidCallback onClear;

  final double? availableHeight;

  @override
  Widget build(BuildContext context) => RadarEmptyState(
    icon: UntitledUI.search_sm,
    title: S.current.noLocationsFound,
    message: S.current.tryAnotherLocation,
    availableHeight: availableHeight,
    action: ButtonSecondary(
      size: ButtonSize.small,
      onPressed: onClear,
      child: Text(S.current.clearSearchBtn),
    ),
  );
}
