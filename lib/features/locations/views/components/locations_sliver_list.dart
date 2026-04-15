import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/enums/screen_type.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/home/views/home_state.dart';
import 'package:mysterium_vpn/features/locations/store/selected_location_store.dart';
import 'package:mysterium_vpn/features/locations/views/components/location_item.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/packages/sliding_up_panel/panel.dart' show PanelController;
import 'package:mysterium_vpn/service_locator.dart';

/// Height of a collapsed [ExpandableLocationItem] (Container minHeight: 64).
const _kItemHeight = 64.0;

/// Separator between items in the SliverList.
const _kSeparatorHeight = 8.0;

/// Combined stride per collapsed item (item + separator).
const _kItemStride = _kItemHeight + _kSeparatorHeight;

/// Full-featured location list with scroll-to-selected support.
///
/// ## Scroll-to-selected strategy
///
/// When a country is selected (via map or connection), the list scrolls to it:
///
///   1. **Collapse** -- suppress the target's auto-expansion so all items have
///      uniform height, making scroll offsets predictable.
///   2. **Jump** -- compute the target offset deterministically using
///      [SliverLayoutBuilder]'s `precedingScrollExtent` + `index * stride`.
///   3. **Fine-tune** -- use `localToGlobal` screen coordinates to adjust for
///      pinned headers. This sidesteps `getOffsetToReveal` which is broken
///      with nested sliver_tools slivers.
///   4. **Expand** -- restore auto-expansion so the target country opens.
class ScrollableLocationsSliverList extends StatefulWidget {
  const ScrollableLocationsSliverList({
    required this.items,
    required this.onItemPressed,
    this.stickyHeaderKey,
    super.key,
  });

  final List<VPNLocation> items;
  final void Function(VPNLocation item) onItemPressed;

  /// Key of the pinned header above this list. Used to position the selected
  /// item just below the header via `localToGlobal` screen coordinates.
  final GlobalKey? stickyHeaderKey;

  @override
  State<ScrollableLocationsSliverList> createState() => _ScrollableLocationsSliverListState();
}

class _ScrollableLocationsSliverListState extends State<ScrollableLocationsSliverList> {
  final _selectedLocationStore = getIt<SelectedLocationStore>();
  final _vpnStore = getIt<VpnStore>();

  Map<String, bool> _expansionOverrides = {};
  int _overridesVersion = 0;
  int _scrollGeneration = 0;
  double _precedingExtent = 0;
  String? _lastPriority;

  String? _computeEffectivePriorityCountryCode() {
    final selectedLocation = _selectedLocationStore.value;
    final connectingLocation = _vpnStore.connectingLocation;
    final connectedLocation = _vpnStore.isConnected ? _vpnStore.location : null;

    final activePriority = selectedLocation?.countryCode ?? connectingLocation?.countryCode;
    if (activePriority != null) {
      _lastPriority = activePriority;
    }
    return activePriority ?? _lastPriority ?? connectedLocation?.countryCode;
  }

  @override
  Widget build(BuildContext context) {
    final screenType = getScreenType(MediaQuery.sizeOf(context));
    final isDesktop = screenType == ScreenType.desktop;

    return Observer(
      builder: (context) {
        final effectivePriorityCountryCode = _computeEffectivePriorityCountryCode();
        final selectedLocation = _selectedLocationStore.value;
        final selectedCC = selectedLocation?.countryCode;

        final priorityIndex = effectivePriorityCountryCode == null
            ? -1
            : widget.items.indexWhere((it) => it.countryCode == effectivePriorityCountryCode);

        final homeState = HomeStateScope.read(context);
        final pc = homeState.panelController;
        final isPanelFullyOpen = !pc.isAttached || pc.isPanelOpen;

        // Clear overrides when priority changes (new selection context).
        if (_lastPriority != effectivePriorityCountryCode) {
          _expansionOverrides = {};
        }

        // Scroll-to-selected effect
        if (priorityIndex != -1 && (isDesktop || isPanelFullyOpen)) {
          if (selectedCC != null || homeState.lastScrolledCountryCode != effectivePriorityCountryCode) {
            homeState.lastScrolledCountryCode = effectivePriorityCountryCode;

            final sc = homeState.scrollController;
            if (sc != null) {
              // Step 1: Collapse the target so all items have uniform height.
              _expansionOverrides = {effectivePriorityCountryCode!: false};
              _overridesVersion++;

              final generation = ++_scrollGeneration;

              _scrollToCountry(
                context: context,
                countryCode: effectivePriorityCountryCode,
                stickyHeaderKey: widget.stickyHeaderKey,
                panelController: homeState.panelController,
                scrollController: sc,
                isDesktop: isDesktop,
                priorityIndex: priorityIndex,
                precedingExtentGetter: () => _precedingExtent,
                generation: generation,
                currentGenerationGetter: () => _scrollGeneration,
                onComplete: () {
                  if (mounted) {
                    setState(() {
                      _expansionOverrides = {};
                      _overridesVersion++;
                    });
                  }
                },
              );
            }
          }
        }

        // Force rebuild tracking.
        // ignore: unused_local_variable
        final _ = _overridesVersion;

        return SliverLayoutBuilder(
          builder: (context, constraints) {
            _precedingExtent = constraints.precedingScrollExtent;

            return SliverList.separated(
              itemCount: widget.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: _kSeparatorHeight),
              itemBuilder: (_, index) {
                final cc = widget.items[index].countryCode;
                return ExpandableLocationItem(
                  key: _LocationKey(cc),
                  location: widget.items[index],
                  onTap: widget.onItemPressed,
                  mapSelectedCountryCode: effectivePriorityCountryCode,
                  expansionOverride: _expansionOverrides[cc],
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _expansionOverrides = {..._expansionOverrides, cc: expanded};
                      _overridesVersion++;
                    });
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Scroll helpers
// ---------------------------------------------------------------------------

/// Scrolls to [countryCode]'s item in the location list.
///
/// Assumes the target item's expansion has already been suppressed (all items
/// have uniform collapsed height) so offset arithmetic is deterministic.
Future<void> _scrollToCountry({
  required BuildContext context,
  required String countryCode,
  required GlobalKey? stickyHeaderKey,
  required PanelController panelController,
  required ScrollController scrollController,
  required bool isDesktop,
  required int priorityIndex,
  required double Function() precedingExtentGetter,
  required int generation,
  required int Function() currentGenerationGetter,
  required VoidCallback onComplete,
}) async {
  bool isStale() =>
      !context.mounted || !scrollController.hasClients || generation != currentGenerationGetter();

  // Wait for the rebuild that collapses all items.
  await WidgetsBinding.instance.endOfFrame;
  if (isStale()) {
    return;
  }

  if (!isDesktop && panelController.isAttached) {
    panelController.enableScrolling();
  }

  // Step 2: Bring the item into view.
  var itemRO = _findItemRenderBox(countryCode);
  if (itemRO == null) {
    // Deterministic offset: content before our SliverList + item stride.
    final roughTarget = precedingExtentGetter() + priorityIndex * _kItemStride;
    scrollController.jumpTo(roughTarget.clamp(0.0, scrollController.position.maxScrollExtent));

    await WidgetsBinding.instance.endOfFrame;
    if (isStale()) {
      return;
    }
    itemRO = _findItemRenderBox(countryCode);
  }
  if (itemRO == null) {
    return;
  }

  // Step 3: Fine-tune using screen coordinates.
  final headerRO = stickyHeaderKey?.currentContext?.findRenderObject();

  final itemScreenY = itemRO.localToGlobal(Offset.zero).dy;
  final headerBottomY = headerRO is RenderBox && headerRO.attached
      ? headerRO.localToGlobal(Offset(0, headerRO.size.height)).dy
      : 0.0;

  final delta = itemScreenY - headerBottomY;
  final fineTarget = (scrollController.offset + delta).clamp(
    0.0,
    scrollController.position.maxScrollExtent,
  );

  if (isDesktop) {
    await scrollController.animateTo(
      fineTarget,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
    );
  } else {
    scrollController.jumpTo(fineTarget);
  }

  // Step 4: Restore expansion.
  if (!isStale()) {
    onComplete();
  }
}

/// Returns the [RenderBox] for a location item by country code, or `null` if
/// the item isn't currently built by the SliverList.
RenderBox? _findItemRenderBox(String countryCode) {
  final ro = _LocationKey(countryCode).currentContext?.findRenderObject() as RenderBox?;
  return (ro != null && ro.attached) ? ro : null;
}

// ---------------------------------------------------------------------------
// GlobalKey with value-based equality for finding LocationItems by country.
// ---------------------------------------------------------------------------

class _LocationKey extends GlobalKey {
  const _LocationKey(this.countryCode) : super.constructor();
  final String countryCode;

  @override
  bool operator ==(Object other) => other is _LocationKey && other.countryCode == countryCode;

  @override
  int get hashCode => Object.hash(_LocationKey, countryCode);
}
