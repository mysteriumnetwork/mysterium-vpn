import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/locations/components/location_item.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LocationsSliverList extends HookConsumerWidget {
  const LocationsSliverList({
    required this.ipType,
    required this.items,
    required this.onItemPressed,
    super.key,
  });

  final List<VPNLocation> items;
  final IPType ipType;
  final void Function(VPNLocation item) onItemPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocationStore = ref.watch(selectedLocationStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final itemScrollController = useMemoized(ItemScrollController.new);
    final scrollOffsetController = useMemoized(ScrollOffsetController.new);
    final itemPositionsListener = useMemoized(ItemPositionsListener.create);
    final scrollOffsetListener = useMemoized(ScrollOffsetListener.create);
    final selectedLocation = useComputedValue(() => selectedLocationStore.value);
    final connectedLocation = useComputedValue(
      () => vpnStore.isConnected ? vpnStore.location : null,
    );

    // Determine which country code should scroll into view (selected takes priority)
    final priorityCountryCode = selectedLocation?.countryCode ?? connectedLocation?.countryCode;

    // Find the index of the priority country (plain expression — no useMemoized needed)
    final priorityIndex = priorityCountryCode == null
        ? -1
        : items.indexWhere((it) => it.countryCode == priorityCountryCode);

    // Scroll to the priority country whenever the index changes
    useEffect(
      () {
        if (priorityIndex == -1) {
          return null;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (itemScrollController.isAttached) {
            itemScrollController.jumpTo(index: priorityIndex);
          }
        });
        return null;
      },
      [
        priorityIndex,
      ],
    );

    return SliverFillRemaining(
      child: ScrollablePositionedList.separated(
        itemScrollController: itemScrollController,
        scrollOffsetController: scrollOffsetController,
        itemPositionsListener: itemPositionsListener,
        scrollOffsetListener: scrollOffsetListener,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) => LocationItem(
          location: items[index],
          onTap: onItemPressed,
        ),
      ),
    );
  }
}
