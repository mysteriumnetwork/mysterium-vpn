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

    final selectedLocation = useComputedValue(() => selectedLocationStore.value);
    final connectedLocation = useComputedValue(
      () => vpnStore.isConnected ? vpnStore.location : null,
    );

    final priorityCountryCode = selectedLocation?.countryCode ?? connectedLocation?.countryCode;
    final priorityIndex = priorityCountryCode == null
        ? -1
        : items.indexWhere((it) => it.countryCode == priorityCountryCode);

    useEffect(
      () {
        if (!scrollToSelected || priorityIndex == -1) {
          return null;
        }
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
            return;
          } else {
            itemScrollController.jumpTo(
              index: priorityIndex,
            );
          }
        });
        return null;
      },
      [priorityCountryCode],
    );

    final mapSelectedCountryCode = selectedLocation?.countryCode;

    if (scrollToSelected && items.isNotEmpty) {
      return SliverLayoutBuilder(
        builder: (context, constraints) => SliverToBoxAdapter(
          child: SizedBox(
            height: constraints.remainingPaintExtent,
            child: ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
              padding: EdgeInsets.only(top: constraints.overlap),
              itemCount: items.length,
              itemBuilder: (_, index) => Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0 : 12),
                child: LocationItem(
                  key: ValueKey(items[index].countryCode),
                  location: items[index],
                  onTap: onItemPressed,
                  mapSelectedCountryCode: mapSelectedCountryCode,
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
        mapSelectedCountryCode: mapSelectedCountryCode,
      ),
    );
  }
}
