import 'package:circle_flags/circle_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/connection_status_color_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/connect_text_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/rate_connection_button.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class ConnectionTile extends HookConsumerWidget {
  const ConnectionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionDisplayStore = ref.watch(connectionDisplayStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);
    final vpnProtocol = ref.watch(vpnProtocolStorePOD);

    final handleToggleConnection = useHandleToggleConnection();

    Future<void> handleRefreshIP() async {
      analyticsStore.logRefreshIP(connectionDisplayStore.connectionIP);
      await vpnStore.manageConnection(refreshIP: true);
    }

    return Observer(
      builder: (context) {
        final location = connectionDisplayStore.displayLocation;
        final parent = connectionDisplayStore.parentLocation;
        final targetLocation = connectionDisplayStore.targetLocation;
        final isLocationAvailable = connectionDisplayStore.isLocationAvailable;
        final ipInfo = connectionDisplayStore.connectionIP;
        final isLoading = connectionDisplayStore.isLoading;
        final intent = connectionDisplayStore.connectionIntent;
        final isConnected = connectionDisplayStore.isConnected;

        final onTap = isLoading
            ? null
            : () => handleToggleConnection(location: targetLocation, intent: intent);

        return _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (location == null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _Placeholder(
                    title: LocaleKeys.connectBestServer.tr(),
                    subtitle: LocaleKeys.orSelectCountryManually.tr(),
                    icon: Asset.icons.connectPrompt(context),
                  ),
                )
              else if (!isLocationAvailable)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _Placeholder(
                    title:
                        LocaleKeys.locationUnavailableTitle.tr(args: [location.getName(context)]),
                    subtitle: LocaleKeys.locationUnavailableSubtitle.tr(),
                    icon: Asset.icons.fix(context),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _Location(
                    location: location,
                    parent: parent,
                    ip: ipInfo,
                    onRefreshIPPressed: handleRefreshIP,
                    isLocationConnected: isConnected,
                  ),
                ),
              ConnectTextButton(
                onPressed: onTap,
                location: targetLocation,
                size: const Size(double.infinity, 42),
                textConnect:
                    targetLocation != location ? LocaleKeys.locationUnavailableAction.tr() : null,
              ),
              if (isConnected) const SizedBox(height: 16),
              if (isConnected) const RateConnection(),
              if (Env.flavor.isDev)
                Text(
                  'Protocol: ${vpnProtocol.protocol.name}',
                  style: const TextStyle(
                    fontSize: 8,
                    color: Palette.pink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Card extends HookWidget {
  const _Card({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = useConnectionStatusColor();

    return Material(
      color: theme.palette.connectionTileBackgroundColor,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: borderColor),
      ),
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final SvgGenImage icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        icon.svg(width: 38, height: 38),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 2,
            children: [
              EasyText(
                title,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              EasyText(
                subtitle,
                fontSize: 12,
                color: theme.palette.subtitleColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Location extends StatelessWidget {
  const _Location({
    required this.location,
    required this.parent,
    required this.ip,
    required this.onRefreshIPPressed,
    required this.isLocationConnected,
  });

  final VPNLocation location;
  final VPNLocation? parent;
  final String? ip;
  final VoidCallback onRefreshIPPressed;
  final bool isLocationConnected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ipType = location.ipType;
    final title = parent?.getName(context) ?? location.getName(context);
    final subtitle = parent != null ? location.getName(context) : null;

    final extras = [
      if (ip != null) ip!,
      if (ipType == IPType.residential)
        LocaleKeys.residential.tr()
      else if (ipType == IPType.datacenter)
        LocaleKeys.highSpeed.tr(),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        CircleFlag(location.countryCode, size: 38),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EasyText(
                title,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: EasyText(subtitle, fontSize: 12, color: theme.palette.subtitleColor),
                ),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 32),
                child: Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: Row(
                        spacing: 8,
                        children: [
                          ...extras
                              .map<Widget>(
                                (it) => Flexible(
                                  child: EasyText(
                                    it,
                                    fontSize: 12,
                                    color: theme.palette.subtitleColor,
                                  ),
                                ),
                              )
                              .separateWith(
                                Container(
                                  color: theme.palette.subtitleColor,
                                  width: 1,
                                  height: 20,
                                ),
                              ),
                        ],
                      ),
                    ),
                    if (ip != null && isLocationConnected)
                      SvgIconButton(
                        asset: Asset.icons.refresh,
                        size: 16,
                        color: theme.palette.subtitleColor,
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: onRefreshIPPressed,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
