import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/connect_text_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/flag.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class LocationItem extends HookConsumerWidget {
  const LocationItem({
    required this.location,
    required this.onTap,
    super.key,
  });

  final VPNLocation location;
  final void Function(VPNLocation) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final vpnStore = ref.watch(vpnStorePOD);
    final remoteConfig = ref.watch(remoteConfigStorePOD);
    final onTap = useComputedValue(() => vpnStore.isLoading ? null : this.onTap, [this.onTap]);
    final children = location.children ?? const <VPNLocation>[];
    final showCitiesAndStates = useComputedValue(
      () => remoteConfig.showCitiesAndStates && children.isNotEmpty,
      [children],
    );
    final isExpanded = useState(false);

    void handleParentPressed() {
      if (showCitiesAndStates) {
        isExpanded.value = !isExpanded.value;
      } else {
        onTap?.call(location);
      }
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 64),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _LocationItem(
            location: location,
            onTap: handleParentPressed,
            onToggleConnectionTap: onTap == null ? null : () => onTap(location),
            label: showCitiesAndStates
                ? LocaleKeys.locationItemCityCount.plural(children.length)
                : LocaleKeys.locationItemNodeCount.plural(location.nodeCount ?? 0),
            isExpanded: showCitiesAndStates ? isExpanded.value : null,
            flag: location.countryCode,
          ),
          if (showCitiesAndStates && isExpanded.value)
            for (final child in children)
              _ChildLocationItem(
                value: child,
                onTap: onTap == null ? null : () => onTap(child),
              ),
        ],
      ),
    );
  }
}

class _ChildLocationItem extends StatelessWidget {
  const _ChildLocationItem({
    required this.value,
    required this.onTap,
  });

  final VPNLocation value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final nodeCount = value.nodeCount ?? 0;
    return _LocationItem(
      location: value,
      onTap: onTap,
      label: LocaleKeys.locationItemNodeCount.plural(nodeCount),
    );
  }
}

class _LocationItem extends StatelessWidget {
  const _LocationItem({
    required this.location,
    required this.onTap,
    required this.label,
    this.onToggleConnectionTap,
    this.isExpanded,
    this.flag,
  });

  final VPNLocation location;
  final VoidCallback? onTap;
  final VoidCallback? onToggleConnectionTap;
  final String label;
  final bool? isExpanded;
  final String? flag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = location.getName(context);
    return RawMaterialButton(
      fillColor: theme.colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 20,
          children: [
            if (flag != null) Flag(countryCode: flag!, size: 30),
            if (flag == null)
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.centerRight,
                child: SvgIcon(
                  height: 20,
                  width: 20,
                  asset: switch (theme.brightness) {
                    Brightness.light => Assets.cityLight,
                    Brightness.dark => Assets.cityDark,
                  },
                ),
              ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 6,
                children: [
                  EasyText(
                    title,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    maxLines: title.hasMultipleWords ? 2 : 1,
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Flexible(
                        child: EasyText(
                          label,
                          fontSize: 12,
                          color: theme.palette.subtitleColor,
                        ),
                      ),
                      if (isExpanded != null)
                        AnimatedRotation(
                          turns: switch (isExpanded ?? false) {
                            false => 0.25,
                            true => 0.75,
                          },
                          duration: const Duration(milliseconds: 200),
                          child: SvgIcon(
                            height: 12,
                            width: 12,
                            asset: switch (theme.brightness) {
                              Brightness.light => Assets.chevronRight,
                              Brightness.dark => Assets.chevronRight,
                            },
                            color: switch (theme.brightness) {
                              Brightness.light => Palette.lightBlack,
                              Brightness.dark => Palette.white,
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            ConnectTextButton(
              onPressed: onToggleConnectionTap ?? onTap,
              location: location,
              size: const Size(90, 38),
              loadingIndicatorRadius: 15,
              borderRadius: 10,
              outlinedButton: true,
            ),
          ],
        ),
      ),
    );
  }
}
