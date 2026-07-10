import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/location_item_state_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart' show locationsQueryStorePOD;
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Expandable location item with per-item expansion state.
///
/// Expansion priority:
///   1. Search match — always expands, overrides everything
///   2. Manual user toggle — only valid while [mapSelectedCountryCode] stays
///      the same; auto-invalidates when selection changes
///   3. Auto — expand the priority country, collapse the rest
class ExpandableLocationItem extends HookConsumerWidget {
  const ExpandableLocationItem({
    required this.location,
    required this.onTap,
    this.mapSelectedCountryCode,
    this.expansionOverride,
    this.onExpansionChanged,
    super.key,
  });

  final VPNLocation location;
  final void Function(VPNLocation) onTap;
  final String? mapSelectedCountryCode;

  /// Manual expansion override managed by the parent list (survives recycling).
  final bool? expansionOverride;

  /// Called when the user manually toggles expansion.
  final ValueChanged<bool>? onExpansionChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsQueryStore = ref.watch(locationsQueryStorePOD);
    final query = useComputedValue(() => locationsQueryStore.searchTrimmed);

    final children = location.children ?? const <VPNLocation>[];

    final (:countryStatus, :items, :subtitle, :needsUpgrade, :showCitiesAndStates, :onConnect) =
        useLocationItemState(location: location, onTap: onTap, ref: ref);

    final isExpanded = useMemoized(() {
      if (!showCitiesAndStates) {
        return false;
      }

      // Rule 1: search match always expands
      final matchesQuery =
          query.isNotEmpty &&
          children.any(
            (it) => it.queried(query, Localizations.localeOf(context).languageCode) != null,
          );
      if (matchesQuery) {
        return true;
      }

      // Rule 2: explicit user toggle (managed by parent, survives recycling)
      if (expansionOverride != null) {
        return expansionOverride!;
      }

      // Rule 3: auto-expand the selected/connected country, collapse the rest
      if (mapSelectedCountryCode != null) {
        return mapSelectedCountryCode == location.countryCode;
      }

      return false;
    }, [query, mapSelectedCountryCode, expansionOverride, showCitiesAndStates, children]);

    return KeyedSubtree(
      key: locationItemKey(location.countryCode),
      child: ExpandableIpCard(
        name: location.getName(context),
        subtitle: subtitle,
        countryIcon: CircleFlag(location.countryCode, size: 24),
        items: items,
        status: countryStatus,
        plusUpgrade: needsUpgrade,
        expanded: isExpanded,
        searchHighlight: query,
        onExpansionChanged: onExpansionChanged,
        onConnect: onConnect,
      ),
    );
  }
}
