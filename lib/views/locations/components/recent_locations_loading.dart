import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/views/locations/components/location_item_loading.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:styled_widget/styled_widget.dart';

class RecentLocationsLoading extends StatelessWidget {
  const RecentLocationsLoading({this.placeholderCount = 10, super.key});

  final int placeholderCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.palette.bgPrimary;
    return MultiSliver(
      children: [
        Shimmer.fromColors(
          baseColor: color,
          highlightColor: color.darken(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Container(width: 200, height: 24, color: Colors.grey[300])],
          ),
        ).width(100),
        SizedBox(height: theme.spacing.ms),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 62),
          child: ListView.separated(
            shrinkWrap: true,
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: placeholderCount,
            separatorBuilder: (_, _) => SizedBox(width: theme.spacing.ms),
            itemBuilder: (_, _) => const LocationItemLoading(),
          ),
        ),
      ],
    );
  }
}
