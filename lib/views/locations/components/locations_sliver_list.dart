import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/screen_type.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/screen_type_hook.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/locations/components/location_item.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LocationsSliverList extends HookConsumerWidget {
  const LocationsSliverList({
    required this.items,
    required this.onItemPressed,
    this.scrollToSelected = false,
    super.key,
  });

  final List<VPNLocation> items;
  final void Function(VPNLocation item) onItemPressed;
  final bool scrollToSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocationStore = ref.watch(selectedLocationStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final screenType = useScreenType();

    final itemScrollController = useMemoized(ItemScrollController.new);

    // Expansion state lives here so it survives tab switches (this widget stays
    // alive while the tab content changes, but LocationItem widgets are recreated).
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

    // Preserve the last non-null value so that scroll target and expanded
    // country are not lost during any brief window where all three sources
    // are simultaneously null.
    final lastPriorityRef = useRef<String?>(priorityCountryCode);
    if (priorityCountryCode != null) {
      lastPriorityRef.value = priorityCountryCode;
    }
    final effectivePriorityCountryCode = priorityCountryCode ?? lastPriorityRef.value;

    final priorityIndex = effectivePriorityCountryCode == null
        ? -1
        : items.indexWhere((it) => it.countryCode == effectivePriorityCountryCode);

    useEffect(
      () {
        if (!scrollToSelected || priorityIndex == -1) {
          return null;
        }
        // Expansion state is updated synchronously during build (via useValueChanged
        // in LocationItem), so the widget tree is correct by end of Frame N.
        // However, ScrollablePositionedList measures item heights during layout —
        // which also completes at end of Frame N. We need those measurements to be
        // stable before calling jumpTo/scrollTo, so we wait one additional frame
        // for ScrollablePositionedList's internal size cache to settle.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!itemScrollController.isAttached) {
              return;
            }
            if (screenType == ScreenType.desktop) {
              itemScrollController.scrollTo(
                index: priorityIndex,
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOut,
              );
            } else {
              itemScrollController.jumpTo(
                index: priorityIndex,
              );
            }
          });
        });
        return null;
      },
      [effectivePriorityCountryCode],
    );

    if (scrollToSelected && items.isNotEmpty) {
      return SliverLayoutBuilder(
        builder: (context, constraints) => SliverToBoxAdapter(
          child: SizedBox(
            height: constraints.remainingPaintExtent.clamp(1.0, double.infinity),
            child: ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
              itemCount: items.length,
              itemBuilder: (_, index) => Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0 : 12),
                child: LocationItem(
                  key: ValueKey(items[index].countryCode),
                  location: items[index],
                  onTap: onItemPressed,
                  userExpanded: userExpanded,
                  userCollapsed: userCollapsed,
                  mapSelectedCountryCode: effectivePriorityCountryCode,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SliverList.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) => LocationItem(
        key: ValueKey(items[index].countryCode),
        location: items[index],
        onTap: onItemPressed,
        userExpanded: userExpanded,
        userCollapsed: userCollapsed,
        mapSelectedCountryCode: effectivePriorityCountryCode,
      ),
    );
  }
}
