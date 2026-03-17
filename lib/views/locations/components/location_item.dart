import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/connect_text_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/flag.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class LocationItem extends HookConsumerWidget {
  const LocationItem({
    required this.location,
    required this.onTap,
    this.mapSelectedCountryCode,
    super.key,
  });

  final VPNLocation location;
  final void Function(VPNLocation) onTap;
  final String? mapSelectedCountryCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final vpnStore = ref.watch(vpnStorePOD);
    final remoteConfig = ref.watch(remoteConfigStorePOD);
    final locationsQueryStore = ref.watch(locationsQueryStorePOD);
    final query = useComputedValue(() => locationsQueryStore.searchTrimmed);

    final children = location.children ?? const <VPNLocation>[];
    final showCitiesAndStates = remoteConfig.showCitiesAndStates && children.isNotEmpty;
    final locationHasStates = remoteConfig.countriesWithStates.contains(location.countryCode);

    final connectedLocation = useComputedValue(
      () => vpnStore.isConnected ? vpnStore.location : null,
    );

    // Manual toggle state
    final userExpanded = useState<Set<String>>({});
    // Manual collapse override (lets user close auto-expanded items)
    final userCollapsed = useState<Set<String>>({});

    // Auto-expand on new connection, reset manual collapse for it
    useValueChanged<String?, void>(connectedLocation?.countryCode, (_, __) {
      if (connectedLocation != null &&
          connectedLocation.countryCode == location.countryCode &&
          showCitiesAndStates) {
        userCollapsed.value = {...userCollapsed.value}..remove(location.id);
        userExpanded.value = {...userExpanded.value, location.id};
      }
    });

    // On map selection: synchronously update manual-override sets so the
    // expansion state is correct in the same build frame (avoiding scroll/expand
    // ordering issues that arise with post-frame effects).
    useValueChanged<String?, void>(mapSelectedCountryCode, (newValue, _) {
      if (newValue == location.countryCode) {
        // This item is now map-selected: clear any manual collapse so it can expand.
        userCollapsed.value = {...userCollapsed.value}..remove(location.id);
      } else if (newValue != null) {
        // Another item is map-selected: clear manual expansion so map-collapse applies.
        userExpanded.value = {...userExpanded.value}..remove(location.id);
      }
    });

    // Derived expansion state
    final isExpanded = useMemoized(
      () {
        if (userCollapsed.value.contains(location.id)) {
          return false;
        }

        final matchesQuery = query.isNotEmpty &&
            children.any((it) => it.queried(query, context.locale.languageCode) != null);

        final connectedMatch =
            connectedLocation != null && connectedLocation.countryCode == location.countryCode;

        final selectedMatch =
            mapSelectedCountryCode != null && mapSelectedCountryCode == location.countryCode;

        final manual = userExpanded.value.contains(location.id);

        return showCitiesAndStates && (matchesQuery || connectedMatch || selectedMatch || manual);
      },
      [
        query.trim(),
        connectedLocation?.countryCode,
        mapSelectedCountryCode,
        userExpanded.value,
        userCollapsed.value,
        children,
      ],
    );

    // Toggle manual expansion
    void handleToggleExpanded() {
      if (isExpanded) {
        // Collapsing — add to collapsed set, remove from expanded set
        userCollapsed.value = {...userCollapsed.value, location.id};
        userExpanded.value = {...userExpanded.value}..remove(location.id);
      } else {
        // Expanding — add to expanded set, remove from collapsed set
        userCollapsed.value = {...userCollapsed.value}..remove(location.id);
        userExpanded.value = {...userExpanded.value, location.id};
      }
    }

    final onTapComputed = useComputedValue(() => vpnStore.isLoading ? null : onTap, [onTap]);

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
            onTap: showCitiesAndStates ? handleToggleExpanded : null,
            onToggleConnectionTap: onTapComputed == null ? null : () => onTapComputed(location),
            label: showCitiesAndStates
                ? locationHasStates
                    ? LocaleKeys.locationItemStatesCount.plural(
                        children.length,
                        namedArgs: {'statesNum': children.length.toString()},
                      )
                    : LocaleKeys.locationItemCityCount.plural(children.length)
                : LocaleKeys.locationItemNodeCount.plural(location.nodeCount ?? 0),
            isExpanded: isExpanded,
            flag: location.countryCode,
            query: query,
          ),
          if (showCitiesAndStates && isExpanded)
            for (final child in children)
              _ChildLocationItem(
                value: child,
                onTap: onTapComputed == null ? null : () => onTapComputed(child),
                query: query,
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
    required this.query,
  });

  final VPNLocation value;
  final VoidCallback? onTap;
  final String query;

  @override
  Widget build(BuildContext context) {
    final nodeCount = value.nodeCount ?? 0;
    return _LocationItem(
      location: value,
      onTap: null,
      onToggleConnectionTap: onTap,
      label: LocaleKeys.locationItemNodeCount.plural(nodeCount),
      query: query,
    );
  }
}

class _LocationItem extends HookWidget {
  const _LocationItem({
    required this.location,
    required this.onTap,
    required this.label,
    required this.query,
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
  final String query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = location.getName(context);
    final isConnected = useIsLocationConnected(location);

    final queryMatchIndex = title.trim().toLowerCase().indexOf(query.trim().toLowerCase());

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
          crossAxisAlignment: flag == null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          spacing: 20,
          children: [
            if (flag != null) Flag(countryCode: flag!, size: 30),
            if (flag == null)
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.centerRight,
                child: SvgIcon(
                  height: 24,
                  width: 24,
                  asset: (isConnected ?? false)
                      ? Asset.icons.cityConnected
                      : Asset.icons.city(context),
                ),
              ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 6,
                children: [
                  Text.rich(
                    queryMatchIndex == -1
                        ? TextSpan(text: title)
                        : TextSpan(
                            children: [
                              TextSpan(
                                text: title.substring(0, queryMatchIndex),
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: title.substring(
                                  queryMatchIndex,
                                  queryMatchIndex + query.length,
                                ),
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  backgroundColor: theme.colorScheme.primary.withValues(alpha: .3),
                                ),
                              ),
                              TextSpan(
                                text: title.substring(queryMatchIndex + query.length),
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
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
                            asset: Asset.icons.chevronRight,
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
