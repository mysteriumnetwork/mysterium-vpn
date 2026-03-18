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

    // When the connected country changes:
    // - If this is the newly connected country: clear manual collapse so Rule 3 can expand it.
    //   Do NOT add to userExpanded — reserved for explicit chevron clicks only.
    // - If a different country connected: clear manual expansion so Rule 3 can collapse this one.
    useValueChanged<String?, void>(connectedLocation?.countryCode, (_, __) {
      if (connectedLocation != null && showCitiesAndStates) {
        if (connectedLocation.countryCode == location.countryCode) {
          userCollapsed.value = {...userCollapsed.value}..remove(location.id);
        } else {
          userExpanded.value = {...userExpanded.value}..remove(location.id);
        }
      }
    });

    // When the map selection changes:
    // - If this item is newly selected: clear stale manual collapse so Rule 3 can expand it.
    // - If a different country is selected: clear manual expansion so Rule 3 can collapse this one.
    useValueChanged<String?, void>(mapSelectedCountryCode, (newValue, _) {
      if (newValue == location.countryCode) {
        userCollapsed.value = {...userCollapsed.value}..remove(location.id);
      } else if (newValue != null) {
        userExpanded.value = {...userExpanded.value}..remove(location.id);
      }
    });

    // Expansion priority (evaluated in order, first match wins):
    //   1. Search match          — always expands, overrides everything
    //   2. Manual user toggle    — userExpanded / userCollapsed wins over auto rules
    //   3. Map-selected/connected — expand the priority country, collapse all others
    final isExpanded = useMemoized(
      () {
        if (!showCitiesAndStates) {
          return false;
        }

        // Rule 1: search match always expands
        final matchesQuery = query.isNotEmpty &&
            children.any((it) => it.queried(query, context.locale.languageCode) != null);
        if (matchesQuery) {
          return true;
        }

        // Rule 2: explicit user toggle
        if (userCollapsed.value.contains(location.id)) {
          return false;
        }
        if (userExpanded.value.contains(location.id)) {
          return true;
        }

        // Rule 3: auto-expand the selected/connected country, collapse the rest
        if (mapSelectedCountryCode != null) {
          return mapSelectedCountryCode == location.countryCode;
        }

        return false;
      },
      [
        query.trim(),
        mapSelectedCountryCode,
        userExpanded.value,
        userCollapsed.value,
        showCitiesAndStates,
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
