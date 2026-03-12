import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/locations/components/location_item.dart';

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
    final homeState = ref.watch(homeStateProvider);
    final selectedLocation = useComputedValue(() => selectedLocationStore.value);
    final connectedLocation = useComputedValue(
      () => vpnStore.isConnected ? vpnStore.location : null,
    );

    final priorityCountryCode = selectedLocation?.countryCode ?? connectedLocation?.countryCode;
    final priorityIndex = priorityCountryCode == null
        ? -1
        : items.indexWhere((it) => it.countryCode == priorityCountryCode);

    final keys = useMemoized(
      () => List.generate(items.length, (_) => GlobalKey()),
      [items.length],
    );

    useEffect(
      () {
        if (priorityIndex == -1) {
          return null;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final ctx = keys[priorityIndex].currentContext;
          if (ctx == null || !ctx.mounted) {
            return;
          }

          // Get pinned header height to offset scroll position
          final pinnedHeight =
              homeState.typeSwitcherKey.currentContext?.findRenderObject()?.paintBounds.height ?? 0;

          // Capture scrollable position before async gap
          final position = Scrollable.of(ctx).position;

          Scrollable.ensureVisible(ctx).then((_) {
            if (!context.mounted) {
              return;
            }
            final target = (position.pixels - pinnedHeight - 5).clamp(
              position.minScrollExtent,
              position.maxScrollExtent,
            );
            position.animateTo(
              target,
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeInOut,
            );
          });
        });
        return null;
      },
      [priorityIndex],
    );

    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            LocationItem(
              key: keys[i],
              location: items[i],
              onTap: onItemPressed,
            ),
          ],
        ],
      ),
    );
  }
}
