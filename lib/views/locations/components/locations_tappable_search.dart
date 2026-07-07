import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A search field that visually mimics [SearchField] but acts as a button:
/// taps trigger [onTap] instead of focusing the underlying text input.
///
/// Used on the Map tab to redirect the user to the Locations tab with the
/// real search field focused.
class LocationsTappableSearch extends StatelessWidget {
  const LocationsTappableSearch({required this.onTap, this.enabled = true, super.key});

  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: IgnorePointer(
        child: SearchField(placeholder: S.current.searchForLocations, enabled: enabled),
      ),
    ),
  );
}
