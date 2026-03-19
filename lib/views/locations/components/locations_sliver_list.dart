import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/screen_type.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/screen_type_hook.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/packages/sliding_up_panel/panel.dart' show PanelController;
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/locations/components/location_item.dart';

/// Lightweight location list without scroll-to-selected logic.
/// Used for top locations where no auto-scrolling is needed.
class LocationsSliverList extends HookConsumerWidget {
  const LocationsSliverList({
    required this.items,
    required this.onItemPressed,
    super.key,
  });

  final List<VPNLocation> items;
  final void Function(VPNLocation item) onItemPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocationStore = ref.watch(selectedLocationStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);

    final userExpanded = useMemoized(() => ValueNotifier<Set<String>>({}));
    final userCollapsed = useMemoized(() => ValueNotifier<Set<String>>({}));
    useEffect(
      () => () {
        userExpanded.dispose();
        userCollapsed.dispose();
      },
      const [],
    );

    final selectedLocation = useComputedValue(() => selectedLocationStore.value);
    final connectingLocation = useComputedValue(() => vpnStore.connectingLocation);
    final connectedLocation = useComputedValue(
      () => vpnStore.isConnected ? vpnStore.location : null,
    );

    final priorityCountryCode = selectedLocation?.countryCode ??
        connectingLocation?.countryCode ??
        connectedLocation?.countryCode;

    final lastPriorityRef = useRef<String?>(priorityCountryCode);
    if (priorityCountryCode != null) {
      lastPriorityRef.value = priorityCountryCode;
    }
    final effectivePriorityCountryCode = priorityCountryCode ?? lastPriorityRef.value;

    return SliverList.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) => LocationItem(
        location: items[index],
        onTap: onItemPressed,
        userExpanded: userExpanded,
        userCollapsed: userCollapsed,
        mapSelectedCountryCode: effectivePriorityCountryCode,
      ),
    );
  }
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
    final selectedLocationStore = ref.watch(selectedLocationStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final screenType = useScreenType();

    final userExpanded = useMemoized(() => ValueNotifier<Set<String>>({}));
    final userCollapsed = useMemoized(() => ValueNotifier<Set<String>>({}));
    useEffect(
      () => () {
        userExpanded.dispose();
        userCollapsed.dispose();
      },
      const [],
    );

    final selectedLocation = useComputedValue(() => selectedLocationStore.value);
    final connectingLocation = useComputedValue(() => vpnStore.connectingLocation);
    final connectedLocation = useComputedValue(
      () => vpnStore.isConnected ? vpnStore.location : null,
    );

    final priorityCountryCode = selectedLocation?.countryCode ??
        connectingLocation?.countryCode ??
        connectedLocation?.countryCode;

    final lastPriorityRef = useRef<String?>(priorityCountryCode);
    if (priorityCountryCode != null) {
      lastPriorityRef.value = priorityCountryCode;
    }
    final effectivePriorityCountryCode = priorityCountryCode ?? lastPriorityRef.value;

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

    useEffect(
      () {
        if (priorityIndex == -1) {
          return null;
        }
        if (homeState.lastScrolledCountryCode == effectivePriorityCountryCode) {
          return null;
        }
        if (!isDesktop && !isPanelFullyOpen) {
          return null;
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
      [effectivePriorityCountryCode, isPanelFullyOpen],
    );

    return SliverList.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) => LocationItem(
        key: _LocationKey(items[index].countryCode),
        location: items[index],
        onTap: onItemPressed,
        userExpanded: userExpanded,
        userCollapsed: userCollapsed,
        mapSelectedCountryCode: effectivePriorityCountryCode,
      ),
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
/// Uses `WidgetsBinding.instance.endOfFrame` to wait for layout passes so
/// that item heights reflect expansion state changes before computing scroll
/// offsets.
Future<void> _scrollToCountry({
  required BuildContext context,
  required String countryCode,
  required GlobalKey? stickyHeaderKey,
  required PanelController panelController,
  required bool isDesktop,
  required int itemCount,
  required int priorityIndex,
}) async {
  // Frame 1: expansion mutations from syncExpansionState fire, triggering a
  // rebuild for the next frame.
  await WidgetsBinding.instance.endOfFrame;
  if (!context.mounted) {
    return;
  }

  // Frame 2: the rebuild has laid out with the correct expansion state.
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
