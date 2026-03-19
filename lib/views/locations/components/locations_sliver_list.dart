import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  const LocationsSliverList({
    required this.items,
    required this.onItemPressed,
    super.key,
  });

  final List<VPNLocation> items;
  final void Function(VPNLocation item) onItemPressed;

  @override
  Widget build(BuildContext context) => SliverList.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) => LocationItem(
          location: items[index],
          onTap: onItemPressed,
        ),
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

        _scrollToCountry(
          context: context,
          countryCode: effectivePriorityCountryCode!,
          stickyHeaderKey: stickyHeaderKey,
          panelController: homeState.panelController,
          isDesktop: isDesktop,
          itemCount: items.length,
          priorityIndex: priorityIndex,
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
            expansionOverrides.value = {
              ...expansionOverrides.value,
              cc: expanded,
            };
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

/// Finds the RenderBox for a location item by its country code GlobalKey.
RenderBox? _findLocationRenderBox(String countryCode) {
  final ctx = _LocationKey(countryCode).currentContext;
  if (ctx == null) {
    return null;
  }
  final ro = ctx.findRenderObject() as RenderBox?;
  return (ro != null && ro.attached) ? ro : null;
}

/// Computes the scroll offset that places [ro] just below the sticky header.
double _targetOffset(
  RenderBox ro,
  ScrollableState scrollable,
  GlobalKey? stickyHeaderKey,
) {
  final viewport = RenderAbstractViewport.of(ro);
  final hRO = stickyHeaderKey?.currentContext?.findRenderObject();
  final stickyHeight = hRO is RenderBox && hRO.attached ? hRO.size.height : 0.0;
  return (viewport.getOffsetToReveal(ro, 0).offset - stickyHeight)
      .clamp(0.0, scrollable.position.maxScrollExtent);
}

/// Scrolls to [countryCode]'s item. On desktop animates; on mobile jumps
/// (after enabling panel scrolling so the panel's reset listener doesn't
/// fight the programmatic scroll).
///
/// Waits one frame for layout to settle before computing scroll offsets.
/// Expansion state is computed synchronously during build (per-item useState),
/// so no extra frames are needed for deferred mutations.
Future<void> _scrollToCountry({
  required BuildContext context,
  required String countryCode,
  required GlobalKey? stickyHeaderKey,
  required PanelController panelController,
  required bool isDesktop,
  required int itemCount,
  required int priorityIndex,
}) async {
  // Wait for layout to settle with the correct expansion state.
  await WidgetsBinding.instance.endOfFrame;
  if (!context.mounted) {
    return;
  }

  final scrollable = Scrollable.maybeOf(context);
  if (scrollable == null) {
    return;
  }

  // On mobile, unlock panel scrolling once so the reset listener doesn't
  // fight programmatic scrolls and the user can scroll normally afterwards.
  if (!isDesktop && panelController.isAttached) {
    panelController.enableScrolling();
  }

  // Fast path: item is already built in the widget tree.
  final ro = _findLocationRenderBox(countryCode);
  if (ro != null) {
    _applyScroll(scrollable, ro, stickyHeaderKey, isDesktop);
    return;
  }

  // Slow path: item is off-screen. Jump to a proportional estimate so the
  // lazy list builds it, then refine after the next layout pass.
  final pos = scrollable.position;
  final estimated = itemCount == 0
      ? 0.0
      : (pos.maxScrollExtent * priorityIndex / itemCount).clamp(0.0, pos.maxScrollExtent);
  pos.jumpTo(estimated);

  await WidgetsBinding.instance.endOfFrame;
  if (!context.mounted) {
    return;
  }

  final refinedRo = _findLocationRenderBox(countryCode);
  if (refinedRo != null) {
    _applyScroll(scrollable, refinedRo, stickyHeaderKey, isDesktop);
  }
}

/// Scrolls to the exact position of [ro]. Desktop animates, mobile jumps.
void _applyScroll(
  ScrollableState scrollable,
  RenderBox ro,
  GlobalKey? stickyHeaderKey,
  bool isDesktop,
) {
  final target = _targetOffset(ro, scrollable, stickyHeaderKey);
  if (isDesktop) {
    scrollable.position.animateTo(
      target,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
    );
  } else {
    scrollable.position.jumpTo(target);
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
