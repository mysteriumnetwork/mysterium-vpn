import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/screen_type.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/location_list_state_hook.dart';
import 'package:mysterium_vpn/common/hooks/screen_type_hook.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/packages/sliding_up_panel/panel.dart' show PanelController;
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/locations/components/location_item.dart';

/// Lightweight location list without scroll-to-selected or expansion logic.
/// Used for top locations which are never expandable.
class LocationsSliverList extends StatelessWidget {
  const LocationsSliverList({required this.items, required this.onItemPressed, super.key});

  final List<VPNLocation> items;
  final void Function(VPNLocation item) onItemPressed;

  @override
  Widget build(BuildContext context) => SliverList.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) => LocationItem(location: items[index], onTap: onItemPressed),
      );
}

/// Full-featured location list with scroll-to-selected support.
/// Watches panel state and uses GlobalKeys to scroll to the selected item.
class ScrollableLocationsSliverList extends HookConsumerWidget {
  const ScrollableLocationsSliverList({
    required this.items,
    required this.onItemPressed,
    this.stickyHeaderKey,
    super.key,
  });

  final List<VPNLocation> items;
  final void Function(VPNLocation item) onItemPressed;

  /// Key of the pinned header widget sitting above this list. Its height is
  /// subtracted from the reveal offset so the selected item appears just below
  /// the header rather than behind it.
  final GlobalKey? stickyHeaderKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectivePriorityCountryCode = useEffectivePriorityCountryCode(ref);
    final screenType = useScreenType();

    final priorityIndex = effectivePriorityCountryCode == null
        ? -1
        : items.indexWhere((it) => it.countryCode == effectivePriorityCountryCode);

    final isDesktop = screenType == ScreenType.desktop;

    // Reactively tracks whether the panel is fully open (animation complete).
    final isPanelFullyOpen = ref.watch(
      homeStateProvider.select((s) {
        final pc = s.panelController;
        if (!pc.isAttached) {
          return true;
        }
        return pc.isPanelOpen;
      }),
    );

    final homeState = ref.read(homeStateProvider);

    // Track selected location so we can re-scroll on re-selection of the
    // same country (the priority stays sticky, so we need this as a dep).
    final selectedLocationStore = ref.watch(selectedLocationStorePOD);
    final selectedLocation = useComputedValue(() => selectedLocationStore.value);
    final selectedCC = selectedLocation?.countryCode;

    // Manual expansion overrides lifted to parent so they survive SliverList
    // recycling (per-item useState is lost when items scroll off-screen).
    final expansionOverrides = useRef<Map<String, bool>>({});
    final overridesVersion = useState(0);

    // Monotonically increasing counter to cancel stale scroll operations.
    // Each new scroll increments this; in-flight scrolls bail when stale.
    final scrollGeneration = useRef(0);

    // Clear overrides when priority changes (new selection context).
    final prevPriority = useRef(effectivePriorityCountryCode);
    if (prevPriority.value != effectivePriorityCountryCode) {
      expansionOverrides.value = {};
      prevPriority.value = effectivePriorityCountryCode;
    }

    useEffect(
      () {
        if (priorityIndex == -1) {
          return null;
        }
        if (!isDesktop && !isPanelFullyOpen) {
          return null;
        }

        // When there's an active selection, always allow scroll (handles
        // re-selection of the same country). For connected/connecting-only
        // changes, use the guard to prevent redundant scrolls.
        if (selectedCC == null) {
          if (homeState.lastScrolledCountryCode == effectivePriorityCountryCode) {
            return null;
          }
        }

        homeState.lastScrolledCountryCode = effectivePriorityCountryCode;

        // Suppress auto-expansion of the target country before scrolling.
        // This ensures the scroll estimate is accurate (all items collapsed).
        // Expansion is restored via onScrollComplete after positioning.
        expansionOverrides.value = {effectivePriorityCountryCode!: false};
        overridesVersion.value++;

        final generation = ++scrollGeneration.value;
        final sc = homeState.scrollController;
        if (sc == null) {
          return null;
        }

        _scrollToCountry(
          context: context,
          countryCode: effectivePriorityCountryCode,
          stickyHeaderKey: stickyHeaderKey,
          panelController: homeState.panelController,
          scrollController: sc,
          isDesktop: isDesktop,
          itemCount: items.length,
          priorityIndex: priorityIndex,
          generation: generation,
          currentGeneration: scrollGeneration,
          onScrollComplete: () {
            // Clear the suppression so Rule 3 auto-expands the target.
            expansionOverrides.value = {};
            overridesVersion.value++;
          },
        );

        return null;
      },
      [effectivePriorityCountryCode, isPanelFullyOpen, selectedCC],
    );

    // Reference overridesVersion so useState triggers rebuilds on toggle.
    // ignore: unused_local_variable
    final _ = overridesVersion.value;

    return SliverList.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        final cc = items[index].countryCode;
        return ExpandableLocationItem(
          key: _LocationKey(cc),
          location: items[index],
          onTap: onItemPressed,
          mapSelectedCountryCode: effectivePriorityCountryCode,
          expansionOverride: expansionOverrides.value[cc],
          onExpansionChanged: (expanded) {
            expansionOverrides.value = {...expansionOverrides.value, cc: expanded};
            overridesVersion.value++;
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Scroll-to-selected helpers
// ---------------------------------------------------------------------------
Future<void> _scrollToCountry({
  required BuildContext context,
  required String countryCode,
  required GlobalKey? stickyHeaderKey,
  required PanelController panelController,
  required ScrollController scrollController,
  required bool isDesktop,
  required int itemCount,
  required int priorityIndex,
  required int generation,
  required ObjectRef<int> currentGeneration,
  required VoidCallback onScrollComplete,
}) async {
  // Wait for the rebuild that collapses all items (expansion suppressed).
  await WidgetsBinding.instance.endOfFrame;
  if (!context.mounted || !scrollController.hasClients || generation != currentGeneration.value) {
    return;
  }

  // On mobile, unlock panel scrolling once so the reset listener doesn't
  // fight programmatic scrolls and the user can scroll normally afterwards.
  if (!isDesktop && panelController.isAttached) {
    panelController.enableScrolling();
  }

  // If the item isn't built yet (off-screen), jump near it first.
  var keyCtx = _LocationKey(countryCode).currentContext;
  if (keyCtx == null) {
    final pos = scrollController.position;
    final estimated = itemCount == 0
        ? 0.0
        : (pos.maxScrollExtent * priorityIndex / itemCount).clamp(0.0, pos.maxScrollExtent);
    scrollController.jumpTo(estimated);

    // Brief real delay so the layout pipeline fully settles after the jump.
    // endOfFrame alone isn't enough — nested sliver_tools slivers need
    // extra layout passes before screen coordinates are accurate.
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (!context.mounted || generation != currentGeneration.value) {
      return;
    }
    keyCtx = _LocationKey(countryCode).currentContext;
  }
  if (keyCtx == null) {
    return;
  }

  // Compute the exact scroll offset using screen coordinates.
  // This works regardless of how many nested sliver_tools wrappers exist.
  final itemRO = keyCtx.findRenderObject() as RenderBox?;
  final headerRO = stickyHeaderKey?.currentContext?.findRenderObject();
  if (itemRO == null || !itemRO.attached) {
    return;
  }

  final itemScreenY = itemRO.localToGlobal(Offset.zero).dy;
  final headerBottomScreenY = headerRO is RenderBox && headerRO.attached
      ? headerRO.localToGlobal(Offset(0, headerRO.size.height)).dy
      : 0.0;

  final scrollDelta = itemScreenY - headerBottomScreenY;
  final target = (scrollController.offset + scrollDelta).clamp(
    0.0,
    scrollController.position.maxScrollExtent,
  );

  if (isDesktop) {
    await scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
    );
  } else {
    scrollController.jumpTo(target);
  }

  // Scroll complete — restore expansion so the target auto-expands.
  if (context.mounted && generation == currentGeneration.value) {
    onScrollComplete();
  }
}

// A GlobalKey that uniquely identifies a LocationItem by countryCode.
// Uses value-based equality so _LocationKey('CA').currentContext finds the
// registered element even when the String object is not identical.
class _LocationKey extends GlobalKey {
  const _LocationKey(this.countryCode) : super.constructor();
  final String countryCode;

  @override
  bool operator ==(Object other) => other is _LocationKey && other.countryCode == countryCode;

  @override
  int get hashCode => Object.hash(_LocationKey, countryCode);
}
