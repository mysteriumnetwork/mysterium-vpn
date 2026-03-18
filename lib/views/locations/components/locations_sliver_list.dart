import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/screen_type.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/screen_type_hook.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/locations/components/location_item.dart';

class LocationsSliverList extends HookConsumerWidget {
  const LocationsSliverList({
    required this.items,
    required this.onItemPressed,
    this.scrollToSelected = false,
    this.stickyHeaderKey,
    super.key,
  });

  final List<VPNLocation> items;
  final void Function(VPNLocation item) onItemPressed;
  final bool scrollToSelected;

  /// Key of the pinned header widget sitting above this list. Its bottom
  /// screen-coordinate is used as the anchor for scroll-to-selected, so the
  /// selected item appears just below the header (not behind it).
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

    // On mobile, only scroll when the panel is fully open so that a map
    // selection does not try to scroll while the panel is still closed.
    // On desktop there is no panel, so treat it as always open.
    final panelState = ref.watch(homeStateProvider.select((s) => s.panelState));
    final isPanelOpen = isDesktop || panelState == PanelState.open;

    useEffect(
      () {
        if (!scrollToSelected || priorityIndex == -1 || !isPanelOpen) {
          return null;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final countryCode = effectivePriorityCountryCode;
            if (countryCode == null) {
              return;
            }
            if (!context.mounted) {
              return;
            }

            // Resolve the outer scrollable from the widget's own context so we
            // can scroll even when the item is not yet in the widget tree.
            final outerScrollable = Scrollable.maybeOf(context);
            if (outerScrollable == null) {
              return;
            }

            // --- Pass 1: rough jump to bring the item to the viewport top ----
            // This ensures every pinned header above the item is in its "pinned"
            // state by the time we measure it in pass 2.
            final itemCtx = _LocationKey(countryCode).currentContext;
            if (itemCtx != null) {
              final ro = itemCtx.findRenderObject() as RenderBox?;
              if (ro != null && ro.attached) {
                final itemGlobalY = ro.localToGlobal(Offset.zero).dy;
                final viewport = RenderAbstractViewport.of(ro);
                final viewportTopY = viewport is RenderBox
                    ? (viewport as RenderBox).localToGlobal(Offset.zero).dy
                    : 0.0;
                final roughOffset = (outerScrollable.position.pixels + itemGlobalY - viewportTopY)
                    .clamp(0.0, outerScrollable.position.maxScrollExtent);
                outerScrollable.position.jumpTo(roughOffset);
              }
            } else {
              // Item not in widget tree – jump to estimated offset so it renders.
              final pos = outerScrollable.position;
              final estimated = (pos.maxScrollExtent * priorityIndex / items.length)
                  .clamp(0.0, pos.maxScrollExtent);
              pos.jumpTo(estimated);
            }

            // --- Pass 2: fine-tune using the now-pinned header's bottom Y ----
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final refinedCtx = _LocationKey(countryCode).currentContext;
              if (refinedCtx == null) {
                return;
              }

              final scrollable = Scrollable.maybeOf(refinedCtx) ?? outerScrollable;
              final ro = refinedCtx.findRenderObject() as RenderBox?;
              if (ro == null || !ro.attached) {
                return;
              }

              final itemGlobalY = ro.localToGlobal(Offset.zero).dy;

              // After the rough jump the sticky header is pinned, so
              // localToGlobal gives its real on-screen bottom coordinate.
              final headerRO = stickyHeaderKey?.currentContext?.findRenderObject() as RenderBox?;
              final double topY;
              if (headerRO != null && headerRO.attached) {
                topY = headerRO.localToGlobal(Offset(0, headerRO.size.height)).dy;
              } else {
                final viewport = RenderAbstractViewport.of(ro);
                topY = viewport is RenderBox
                    ? (viewport as RenderBox).localToGlobal(Offset.zero).dy
                    : 0.0;
              }

              // Scroll so that item's top lands at topY (just below sticky header).
              final targetOffset = (scrollable.position.pixels + itemGlobalY - topY)
                  .clamp(0.0, scrollable.position.maxScrollExtent);

              if (isDesktop) {
                scrollable.position.animateTo(
                  targetOffset,
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeOut,
                );
              } else {
                scrollable.position.jumpTo(targetOffset);
              }
            });
          });
        });

        return null;
      },
      [effectivePriorityCountryCode, priorityIndex, isPanelOpen],
    );

    return SliverList.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) => LocationItem(
        key: scrollToSelected
            ? _LocationKey(items[index].countryCode)
            : ValueKey(items[index].countryCode),
        location: items[index],
        onTap: onItemPressed,
        userExpanded: userExpanded,
        userCollapsed: userCollapsed,
        mapSelectedCountryCode: effectivePriorityCountryCode,
      ),
    );
  }
}

// A GlobalKey that uniquely identifies a LocationItem by countryCode.
// Uses value-based equality so _LocationKey('CA').currentContext finds the
// registered element even when the String object is not identical (e.g.
// runtime strings loaded from a store).
class _LocationKey extends GlobalKey {
  const _LocationKey(this.countryCode) : super.constructor();
  final String countryCode;

  @override
  bool operator ==(Object other) => other is _LocationKey && other.countryCode == countryCode;

  @override
  int get hashCode => Object.hash(_LocationKey, countryCode);
}
