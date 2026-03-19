import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/views/locations/components/location_item.dart';

class LocationsSliverList extends StatelessWidget {
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
  Widget build(BuildContext context) => SliverList.separated(
    itemCount: items.length,
    separatorBuilder: (_, _) => const SizedBox(height: 12),
    itemBuilder: (_, index) {
      final item = items[index];
      return LocationItem(location: item, onTap: onItemPressed);
    },
  );
}
