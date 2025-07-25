import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/views/locations/components/location_item.dart';
import 'package:shimmer/shimmer.dart';

class LocationsSliverLoading extends StatelessWidget {
  const LocationsSliverLoading({
    this.placeholderCount = 10,
    super.key,
  });

  final int placeholderCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverList.separated(
      itemCount: placeholderCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) {
        final color = theme.colorScheme.secondary;
        return Shimmer.fromColors(
          baseColor: color,
          highlightColor: color.darken(20),
          child: LocationItem(
            location: const VPNLocation(
              id: 'mock',
              ipType: IPType.residential,
              translations: {'en': 'mock'},
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}
