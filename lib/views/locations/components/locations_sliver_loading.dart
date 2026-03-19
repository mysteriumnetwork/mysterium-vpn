import 'package:flutter/material.dart';
import 'package:mysterium_vpn/views/locations/components/location_item_loading.dart';

class LocationsSliverLoading extends StatelessWidget {
  const LocationsSliverLoading({this.placeholderCount = 10, super.key});

  final int placeholderCount;

  @override
  Widget build(BuildContext context) => SliverList.separated(
    itemCount: placeholderCount,
    separatorBuilder: (_, _) => const SizedBox(height: 12),
    itemBuilder: (_, _) => const LocationItemLoading(),
  );
}
