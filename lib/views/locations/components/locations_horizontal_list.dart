import 'package:circle_flags/circle_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/horizontal_scroll_indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';

class LocationsHorizontalList extends HookWidget {
  const LocationsHorizontalList({
    required this.title,
    required this.items,
    required this.onItemPressed,
    this.listConstraints = const BoxConstraints(maxHeight: 64),
    super.key,
  });

  final String title;
  final List<VPNLocation> items;
  final void Function(VPNLocation) onItemPressed;
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
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final item = items[index];
          return _Item(
            value: item,
            onPressed: () => onItemPressed(item),
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
    final hasIndicator = useResponsiveValue(
      false,
      desktop: true,
      tablet: true,
    );

    Widget child = ConstrainedBox(
      constraints: constraints,
      child: this.child,
    );

    if (hasIndicator) {
      child = HorizontalScrollIndicator(
        controller: scrollController,
        child: child,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 14,
      children: [
        EasyText(
          title,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        child,
      ],
    );
  }
}

class _Item extends HookWidget {
  const _Item({
    required this.value,
    required this.onPressed,
  });

  final VPNLocation value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      clipBehavior: Clip.hardEdge,
      constraints: BoxConstraints.tight(const Size(210, 64)),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      fillColor: theme.colorScheme.tertiaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        spacing: 8,
        children: [
          CircleFlag(
            value.countryCode,
            size: 24,
            shape: const CircleBorder(
              side: BorderSide(
                color: Palette.white,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                EasyText(
                  value.getName(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                if (value.ipType == IPType.datacenter)
                  EasyText(
                    LocaleKeys.highSpeed.tr(),
                    fontSize: 12,
                    color: theme.palette.subtitleColor,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
