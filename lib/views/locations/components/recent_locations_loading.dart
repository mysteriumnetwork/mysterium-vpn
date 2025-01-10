import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/views/locations/components/recent_location_item.dart';
import 'package:shimmer/shimmer.dart';

class RecentLocationsLoading extends StatelessWidget {
  const RecentLocationsLoading({
    this.placeholderCount = 10,
    super.key,
  });

  final int placeholderCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 124),
      child: ListView.separated(
        shrinkWrap: true,
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: placeholderCount,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) {
          final color = theme.colorScheme.secondary;
          return Shimmer.fromColors(
            baseColor: color,
            highlightColor: color.darken(20),
            child: RecentLocationItem(location: const VPNLocation(code: 'mock'), onTap: () {}),
          );
        },
      ),
    );
  }
}
