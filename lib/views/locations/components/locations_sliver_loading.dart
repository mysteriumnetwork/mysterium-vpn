import 'package:flutter/material.dart';
import 'package:mysterium_vpn/views/locations/components/location_item_loading.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationsSliverLoading extends StatelessWidget {
  const LocationsSliverLoading({this.placeholderCount = 10, super.key});

  final int placeholderCount;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).spacing;
    return SliverList.separated(
      itemCount: placeholderCount,
      separatorBuilder: (_, _) => SizedBox(height: spacing.ms),
      itemBuilder: (_, _) => const LocationItemLoading(),
    );
  }
}
