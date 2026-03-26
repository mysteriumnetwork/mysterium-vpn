import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:shimmer/shimmer.dart';

class LocationItemLoading extends StatelessWidget {
  const LocationItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      constraints: const BoxConstraints(maxWidth: 360, minHeight: 82),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Shimmer.fromColors(
        baseColor: color,
        highlightColor: color.darken(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 160, height: 16, color: Colors.grey[300]),
                const SizedBox(height: 8),
                Container(width: 80, height: 10, color: Colors.grey[300]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
