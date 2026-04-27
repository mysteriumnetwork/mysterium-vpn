import 'package:circle_flags/circle_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/extensions/vpn_location.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationsHorizontalList extends StatefulWidget {
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
  State<LocationsHorizontalList> createState() => _LocationsHorizontalListState();
}

class _LocationsHorizontalListState extends State<LocationsHorizontalList> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _Container(
    title: widget.title,
    constraints: widget.listConstraints,
    scrollController: _scrollController,
    child: ListView.separated(
      itemCount: widget.items.length,
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (_, _) => SizedBox(width: Theme.of(context).spacing.ms),
      itemBuilder: (_, index) {
        final item = widget.items[index];
        final isConnected =
            widget.connectedLocation != null && widget.connectedLocation!.id == item.id;
        return LocationCard(
          icon: CircleFlag(item.countryCode, size: 24),
          name: item.getName(context),
          subtitle: item.ipType == IPType.datacenter
              ? LocaleKeys.highSpeed.tr()
              : LocaleKeys.residential.tr(),
          onTap: () => widget.onItemPressed(item),
          status: isConnected ? LocationCardStatus.selected : LocationCardStatus.idle,
        );
      },
    ),
  );
}

class _Container extends StatelessWidget {
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
    final screenType = ScreenType.of(context);
    final hasIndicator = screenType >= ScreenType.tablet;

    Widget child = ConstrainedBox(constraints: constraints, child: this.child);

    if (hasIndicator) {
      child = HorizontalScrollIndicator(controller: scrollController, child: child);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Theme.of(context).spacing.md,
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
