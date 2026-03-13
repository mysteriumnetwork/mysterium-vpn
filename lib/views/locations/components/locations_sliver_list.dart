import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/locations/components/location_item.dart';

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

    final scrollController = useScrollController();
    final listKey = useMemoized(GlobalKey.new, []);
    final keys = useMemoized(
      () => List.generate(items.length, (_) => GlobalKey()),
      [items.length],
    );
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
          final ctx = keys[priorityIndex].currentContext;
          if (ctx == null || !ctx.mounted) {
            return;
          }
          final itemBox = ctx.findRenderObject();
          if (itemBox is! RenderBox || !itemBox.attached) {
            return;
          }
          if (!scrollController.hasClients) {
            return;
          }
          final listBox = listKey.currentContext?.findRenderObject();
          if (listBox is! RenderBox || !listBox.attached) {
            return;
          }
          final itemOffsetInList =
              itemBox.localToGlobal(Offset.zero).dy - listBox.localToGlobal(Offset.zero).dy;
          final target = (scrollController.offset + itemOffsetInList).clamp(
            scrollController.position.minScrollExtent,
            scrollController.position.maxScrollExtent,
          );
          scrollController.animateTo(
            target,
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeInOut,
          );
        });
        return null;
      },
      [priorityIndex],
    );

    final mapSelectedCountryCode = selectedLocation?.countryCode;

    if (scrollToSelected && items.isNotEmpty) {
      return SliverLayoutBuilder(
        builder: (context, constraints) => SliverToBoxAdapter(
          child: SizedBox(
            height: constraints.remainingPaintExtent,
            child: ListView.separated(
              key: listKey,
              controller: scrollController,
              padding: EdgeInsets.zero,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) => LocationItem(
                key: keys[index],
                location: items[index],
                onTap: onItemPressed,
                mapSelectedCountryCode: mapSelectedCountryCode,
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
        key: keys[index],
        location: items[index],
        onTap: onItemPressed,
        mapSelectedCountryCode: mapSelectedCountryCode,
      ),
    );
  }
}
