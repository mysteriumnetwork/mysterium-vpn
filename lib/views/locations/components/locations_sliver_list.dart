import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/location_list_state_hook.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/arrowed_progress_card.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/locations/components/location_item.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:showcaseview/showcaseview.dart';

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
///   1. **Collapse** — suppress the target's auto-expansion so all items have
///      uniform height, making scroll offsets predictable.
///   2. **Jump** — compute the target offset deterministically using
///      [SliverLayoutBuilder]'s `precedingScrollExtent` + `index * stride`.
///   3. **Fine-tune** — use `localToGlobal` screen coordinates to adjust for
///      pinned headers. This sidesteps `getOffsetToReveal` which is broken
///      with nested sliver_tools slivers.
///   4. **Expand** — restore auto-expansion so the target country opens.
class ScrollableLocationsSliverList extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final effectivePriorityCountryCode = useEffectivePriorityCountryCode(ref);
    final screenType = ScreenType.of(context);
    final onboarding = ref.watch(subscriptionOnboardingShowcasePOD);

    final priorityIndex = effectivePriorityCountryCode == null
        ? -1
        : items.indexWhere((it) => it.countryCode == effectivePriorityCountryCode);

    final isDesktop = screenType == ScreenType.desktop;

    final homeState = ref.read(homeStateProvider);

    final selectedLocationStore = ref.watch(selectedLocationStorePOD);
    final selectedLocation = useComputedValue(() => selectedLocationStore.value);
    final selectedCC = selectedLocation?.countryCode;

    // --- Expansion state ---
    final expansionOverrides = useRef<Map<String, bool>>({});
    final overridesVersion = useState(0);
    final scrollGeneration = useRef(0);

    // Captured each layout pass by SliverLayoutBuilder below.
    final precedingExtent = useRef<double>(0);

    // Clear overrides when priority changes (new selection context).
    final prevPriority = useRef(effectivePriorityCountryCode);
    if (prevPriority.value != effectivePriorityCountryCode) {
      expansionOverrides.value = {};
      prevPriority.value = effectivePriorityCountryCode;
    }

    // --- Scroll-to-selected effect ---
    useEffect(() {
      if (priorityIndex == -1) {
        return null;
      }

      // Allow re-scroll on re-selection; guard redundant connected-only scrolls.
      if (selectedCC == null) {
        if (homeState.lastScrolledCountryCode == effectivePriorityCountryCode) {
          return null;
        }
      }

      homeState.lastScrolledCountryCode = effectivePriorityCountryCode;

      final sc = homeState.scrollController;
      if (sc == null) {
        return null;
      }

      // Step 1: Collapse the target so all items have uniform height.
      expansionOverrides.value = {effectivePriorityCountryCode!: false};
      overridesVersion.value++;

      final generation = ++scrollGeneration.value;

      // Steps 2–4 happen asynchronously.
      _scrollToCountry(
        context: context,
        countryCode: effectivePriorityCountryCode,
        stickyHeaderKey: stickyHeaderKey,
        scrollController: sc,
        isDesktop: isDesktop,
        priorityIndex: priorityIndex,
        precedingExtent: precedingExtent,
        generation: generation,
        currentGeneration: scrollGeneration,
        onComplete: () {
          // Step 4: Clear suppression → target auto-expands via Rule 3.
          expansionOverrides.value = {};
          overridesVersion.value++;
        },
      );

      return null;
    }, [effectivePriorityCountryCode, selectedCC]);

    // Force rebuild when overrides change.
    // ignore: unused_local_variable
    final _ = overridesVersion.value;

    // --- Build the list ---
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        precedingExtent.value = constraints.precedingScrollExtent;
        final showcaseStartIndex = _showcaseStartIndex(
          constraints: constraints,
          itemCount: items.length,
          enabled: isDesktop,
        );

        return SliverList.separated(
          itemCount: showcaseStartIndex == null ? items.length : items.length - 1,
          separatorBuilder: (_, _) => const SizedBox(height: _kSeparatorHeight),
          itemBuilder: (_, index) {
            if (index == showcaseStartIndex) {
              final start = showcaseStartIndex!;
              final firstLocation = items[start];
              final secondLocation = items[start + 1];
              final stepIndex = onboarding.locationsListStepIndex;

              return ArrowedProgressCard(
                tooltipIndex: stepIndex,
                totalTooltips: onboarding.visibleStepsCount,
                tooltipContent: onboarding.locationsListTooltipContent,
                globalKey: onboarding.locationsListKey,
                tooltipPosition: TooltipPosition.top,
                icon: onboarding.locationsListTooltipContent.icon,
                onActionPressed: () => onboarding.showNextTip(stepIndex),
                child: Column(
                  children: [
                    _LocationListItem(
                      location: firstLocation,
                      onItemPressed: onItemPressed,
                      effectivePriorityCountryCode: effectivePriorityCountryCode,
                      expansionOverride: expansionOverrides.value[firstLocation.countryCode],
                      onExpansionChanged: (expanded) {
                        expansionOverrides.value = {
                          ...expansionOverrides.value,
                          firstLocation.countryCode: expanded,
                        };
                        overridesVersion.value++;
                      },
                    ),
                    const SizedBox(height: _kSeparatorHeight),
                    _LocationListItem(
                      location: secondLocation,
                      onItemPressed: onItemPressed,
                      effectivePriorityCountryCode: effectivePriorityCountryCode,
                      expansionOverride: expansionOverrides.value[secondLocation.countryCode],
                      onExpansionChanged: (expanded) {
                        expansionOverrides.value = {
                          ...expansionOverrides.value,
                          secondLocation.countryCode: expanded,
                        };
                        overridesVersion.value++;
                      },
                    ),
                  ],
                ),
              );
            }

            final itemIndex = showcaseStartIndex != null && index > showcaseStartIndex
                ? index + 1
                : index;

            return _LocationListItem(
              location: items[itemIndex],
              onItemPressed: onItemPressed,
              effectivePriorityCountryCode: effectivePriorityCountryCode,
              expansionOverride: expansionOverrides.value[items[itemIndex].countryCode],
              onExpansionChanged: (expanded) {
                expansionOverrides.value = {
                  ...expansionOverrides.value,
                  items[itemIndex].countryCode: expanded,
                };
                overridesVersion.value++;
              },
            );
          },
        );
      },
    );
  }
}

class _LocationListItem extends StatelessWidget {
  const _LocationListItem({
    required this.location,
    required this.onItemPressed,
    required this.effectivePriorityCountryCode,
    required this.onExpansionChanged,
    this.expansionOverride,
  });

  final VPNLocation location;
  final void Function(VPNLocation item) onItemPressed;
  final String? effectivePriorityCountryCode;
  final bool? expansionOverride;
  final ValueChanged<bool> onExpansionChanged;

  @override
  Widget build(BuildContext context) => ExpandableLocationItem(
    key: _LocationKey(location.countryCode),
    location: location,
    onTap: onItemPressed,
    mapSelectedCountryCode: effectivePriorityCountryCode,
    expansionOverride: expansionOverride,
    onExpansionChanged: onExpansionChanged,
  );
}

int? _showcaseStartIndex({
  required SliverConstraints constraints,
  required int itemCount,
  required bool enabled,
}) {
  if (!enabled || itemCount < 2) {
    return null;
  }

  final firstVisibleIndex = (constraints.scrollOffset / _kItemStride).floor();
  final visibleCount = (constraints.remainingPaintExtent / _kItemStride).floor().clamp(
    2,
    itemCount,
  );

  return (firstVisibleIndex + visibleCount - 2).clamp(0, itemCount - 2);
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
  required ScrollController scrollController,
  required bool isDesktop,
  required int priorityIndex,
  required ObjectRef<double> precedingExtent,
  required int generation,
  required ObjectRef<int> currentGeneration,
  required VoidCallback onComplete,
}) async {
  bool isStale() =>
      !context.mounted || !scrollController.hasClients || generation != currentGeneration.value;

  // Wait for the rebuild that collapses all items.
  await WidgetsBinding.instance.endOfFrame;
  if (isStale()) {
    return;
  }

  // Step 2: Bring the item into view.
  var itemRO = _findItemRenderBox(countryCode);
  if (itemRO == null) {
    // Deterministic offset: content before our SliverList + item stride.
    final roughTarget = precedingExtent.value + priorityIndex * _kItemStride;
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
