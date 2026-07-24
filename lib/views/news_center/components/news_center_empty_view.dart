import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/views/news_center/news_center_strings.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Empty state for the News Center: a bell glyph surrounded by concentric
/// "radar" rings with a short explanation, shown when the feed loaded
/// successfully but contains no items.
///
/// See [RadarEmptyState] for how [availableHeight] adapts the top padding.
class NewsCenterEmptyView extends StatelessWidget {
  const NewsCenterEmptyView({this.availableHeight, super.key});

  final double? availableHeight;

  @override
  Widget build(BuildContext context) => RadarEmptyState(
    icon: UntitledUI.bell_01,
    title: newsCenterEmptyTitleText,
    message: newsCenterEmptySubtitleText,
    availableHeight: availableHeight,
    // Sit the icon further below the tabs bar than the default empty state.
    mobileTopPadding: 130,
    desktopTopPadding: 160,
  );
}
