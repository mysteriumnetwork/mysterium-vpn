import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/views/locations/components/recent_location_item.dart';

class RecentLocationsList extends StatelessWidget {
  const RecentLocationsList({
    required this.items,
    required this.onItemPressed,
    this.constraints = const BoxConstraints(maxHeight: 132),
    super.key,
  });

  final List<VPNLocation> items;
  final void Function(VPNLocation item) onItemPressed;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: constraints,
        child: ListView.separated(
          shrinkWrap: true,
          clipBehavior: Clip.none,
          itemCount: items.length,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, index) {
            final item = items[index];
            return RecentLocationItem(
              location: item,
              onTap: () => onItemPressed(item),
            );
          },
        ),
      );
}
