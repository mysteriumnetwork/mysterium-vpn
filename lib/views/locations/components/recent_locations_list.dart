import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/components/horizontal_scroll_indicator.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/views/locations/components/recent_location_item.dart';

class RecentLocationsList extends HookWidget {
  const RecentLocationsList({
    required this.items,
    required this.onItemPressed,
    this.constraints = const BoxConstraints(maxHeight: 82),
    super.key,
  });

  final List<VPNLocation> items;
  final void Function(VPNLocation item) onItemPressed;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    return ConstrainedBox(
      constraints: constraints,
      child: HorizontalScrollIndicator(
        controller: scrollController,
        child: ListView.separated(
          controller: scrollController,
          itemCount: items.length,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, index) {
            final item = items[index];
            return Align(
              alignment: Alignment.topLeft,
              child: RecentLocationItem(
                location: item,
                onTap: () => onItemPressed(item),
              ),
            );
          },
        ),
      ),
    );
  }
}
