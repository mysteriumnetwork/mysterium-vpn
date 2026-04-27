import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/extensions/extensions.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:shimmer/shimmer.dart';

class LocationItemLoading extends StatelessWidget {
  const LocationItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.palette.bgPrimary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.ms, vertical: theme.spacing.s),
      constraints: const BoxConstraints(maxWidth: 360, maxHeight: 40),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(theme.spacing.s)),
      child: Shimmer.fromColors(
        baseColor: color,
        highlightColor: color.darken(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color.darken(20).withValues(alpha: 150),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            SizedBox(width: theme.spacing.ms),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 160, height: 16, color: color.darken(20).withValues(alpha: 150)),
                SizedBox(height: theme.spacing.xs),
                Container(width: 90, height: 8, color: color.darken(20).withValues(alpha: 150)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
