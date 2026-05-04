import 'package:circle_flags/circle_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationsHorizontalList extends HookWidget {
  const LocationsHorizontalList({
    required this.title,
    required this.items,
    required this.onItemPressed,
    this.connectedLocation,
    this.listConstraints = const BoxConstraints(maxHeight: 66),
    super.key,
  });

  final String title;
  final List<VPNLocation> items;
  final void Function(VPNLocation) onItemPressed;
  final VPNLocation? connectedLocation;
  final BoxConstraints listConstraints;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    return _Container(
      title: title,
      constraints: listConstraints,
      scrollController: scrollController,
      child: ListView.separated(
        itemCount: items.length,
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, _) => SizedBox(width: Theme.of(context).spacing.ms),
        itemBuilder: (_, index) {
          final item = items[index];
          final isConnected = connectedLocation != null && connectedLocation!.id == item.id;
          return LocationCard(
            icon: CircleFlag(item.countryCode, size: 24),
            name: item.getName(context),
            subtitle: item.ipType == IPType.datacenter
                ? LocaleKeys.highSpeed.tr()
                : LocaleKeys.residential.tr(),
            onTap: () => onItemPressed(item),
            status: isConnected ? LocationCardStatus.selected : LocationCardStatus.idle,
          );
        },
      ),
    );
  }
}

class _Container extends HookWidget {
  const _Container({
    required this.title,
    required this.constraints,
    required this.scrollController,
    required this.child,
  });

  final String title;
  final BoxConstraints constraints;
  final ScrollController scrollController;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final hasIndicator = ScreenType.of(context) != ScreenType.mobile;

    Widget child = ConstrainedBox(constraints: constraints, child: this.child);

    if (hasIndicator) {
      child = HorizontalScrollIndicator(controller: scrollController, child: child);
    }

    final spacing = Theme.of(context).spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: spacing.md,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textStyles.textMd.semibold.copyWith(color: Theme.of(context).palette.textTertiary),
        ),
        child,
      ],
    );
  }
}
