import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

class LocationTypeSwitcher extends StatelessWidget {
  const LocationTypeSwitcher({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final IPType value;
  final ValueChanged<IPType> onChanged;

  @override
  Widget build(BuildContext context) {
    final values = [IPType.datacenter, IPType.residential];

    return Row(
      children: [
        for (final value in values)
          Expanded(
            child: _Item(
              alignment: values.length > 1 ? MainAxisAlignment.center : MainAxisAlignment.start,
              onTap: values.length > 1 ? () => onChanged(value) : null,
              label: switch (value) {
                IPType.datacenter => LocaleKeys.ipTypeDataCenter.tr(),
                _ => values.length > 1
                    ? LocaleKeys.ipTypeResidential.tr()
                    : LocaleKeys.allLocations.tr(),
              },
              icon: switch (value) {
                IPType.datacenter => SvgIcon(asset: Asset.icons.speed, height: 20),
                _ => null,
              },
              selected: values.length > 1 && value == this.value,
            ),
          ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.alignment,
  });

  final String label;
  final Widget? icon;
  final bool selected;
  final MainAxisAlignment alignment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RawMaterialButton(
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      splashColor: Colors.transparent,
      hoverElevation: 0,
      constraints: const BoxConstraints(minHeight: 56),
      visualDensity: VisualDensity.compact,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      fillColor: selected ? theme.colorScheme.tertiaryContainer : Colors.transparent,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          mainAxisAlignment: alignment,
          children: [
            Flexible(
              child: EasyText(
                label,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 16,
                textDecoration: !selected ? null : TextDecoration.underline,
                colorDecoration: theme.textTheme.bodyMedium?.color,
              ),
            ),
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: icon,
              ),
          ],
        ),
      ),
    );
  }
}
