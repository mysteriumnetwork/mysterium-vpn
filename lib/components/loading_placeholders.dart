import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/components/circle_box.dart';
import 'package:shimmer/shimmer.dart';
import 'package:styled_widget/styled_widget.dart';

class RecentLocationPlaceholder extends StatelessWidget {
  const RecentLocationPlaceholder({required this.color, super.key});
  final Color color;
  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: color,
    highlightColor: color.darken(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleBox(size: 16, color: color).paddingDirectional(bottom: 24),
        Container(
          width: double.infinity,
          height: 8,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: color),
        ).paddingDirectional(bottom: 12),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 8,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: color),
        ),
      ],
    ).padding(horizontal: 10, vertical: 4).width(110),
  ).card().paddingDirectional(end: 15);
}

class LocationPlaceholder extends StatelessWidget {
  const LocationPlaceholder({required this.color, super.key});
  final Color color;
  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: color,
    highlightColor: color.darken(20),
    child: Row(
      children: [
        CircleBox(size: 10, color: color).paddingDirectional(end: 12),
        Container(
          width: 78,
          height: 8,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: color),
        ),
        const Spacer(),
        CircleBox(size: 16, color: color),
      ],
    ).padding(horizontal: 15, vertical: 20),
  ).card(color: Theme.of(context).cardColor).padding(bottom: 10);
}
