import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Tooltip;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/enums/indicator_type.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/circle_box.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/flag.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/refresh_connection.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/components/tooltip.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/vpn_connection.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:wireguard_dart/connection_status.dart';

class MobileConnectionStatusBar extends HookConsumerWidget {
  const MobileConnectionStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final isLoading = useComputedValue(() => vpnStore.isLoading);
    final connectionStatus = useComputedValue(() => vpnStore.connectionStatus);
    final isConnected = useComputedValue(() => vpnStore.isConnected);

    final vpnConnection = useComputedValue(() => vpnStore.vpnConnection);

    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _IPItem(
              isConnected: isConnected,
              connection: vpnConnection,
            ),
            const SizedBox(width: 8),
            _StatusItem(
              status: connectionStatus,
              isLoading: isLoading,
              layoutConstraints: constraints,
            ),
            const SizedBox(width: 8),
            _LocationItem(
              location: vpnConnection?.location,
              isConnected: isConnected,
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.label,
    required this.children,
  });
  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EasyText(
              label,
              color: Palette.lightBlue,
              fontWeight: FontWeight.w400,
              fontSize: 10,
            ),
            const SizedBox(height: 2),
            ...children.map(
              (child) => Padding(padding: const EdgeInsets.only(top: 8), child: child),
            ),
          ],
        ),
      );
}

class _IPItem extends HookWidget {
  const _IPItem({
    required this.connection,
    required this.isConnected,
  });

  final VpnConnection? connection;
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    final isResolvingConnectionIP = connection?.isResolvingconnectionIP ?? false;
    final ip = useMemoized(
      () {
        if (!isConnected || connection == null) {
          return '--';
        }
        return connection!.connectionIP;
      },
      [isConnected, connection],
    );

    return _Item(
      label: LocaleKeys.connectionIp.tr(),
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isConnected && connection?.location.ipType == IPType.datacenter)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: SvgIcon(asset: Assets.speed, height: 12),
              ),
            Flexible(
              child: !isResolvingConnectionIP
                  ? EasyText(ip, fontSize: 12)
                  : const LoadingIndicator(radius: 15),
            ),
          ],
        ),
        if (isConnected) const RefreshConnection(),
      ],
    );
  }
}

class _StatusItem extends StatelessWidget {
  const _StatusItem({
    required this.status,
    required this.isLoading,
    required this.layoutConstraints,
  });

  final bool isLoading;
  final ConnectionStatus status;
  final BoxConstraints layoutConstraints;

  @override
  Widget build(BuildContext context) {
    final status = isLoading ? ConnectionStatus.connecting : this.status;

    return _Item(
      label: LocaleKeys.status.tr(),
      children: [
        Tooltip(
          enabled: status == ConnectionStatus.connected,
          type: TooltipType.killSwitch,
          buildEntry: (context) => TooltipEntry(
            title: LocaleKeys.killSwitchTooltipTitle.tr(),
            message: LocaleKeys.killSwitchTooltipMessage.tr(),
            constraints: layoutConstraints
                .copyWith(maxWidth: layoutConstraints.maxWidth * .7)
                .widthConstraints(),
          ),
          child: DecoratedBox(
            decoration: switch (status) {
              ConnectionStatus.connected => BoxDecoration(
                  color: Palette.green,
                  borderRadius: BorderRadius.circular(20),
                ),
              _ => const BoxDecoration(),
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  switch (status) {
                    ConnectionStatus.connected =>
                      const SvgIcon(asset: Assets.killSwitch, height: 9),
                    ConnectionStatus.disconnected => const CircleBox(color: Palette.pink, size: 4),
                    _ => const SizedBox.shrink(),
                  },
                  const SizedBox(width: 4),
                  Flexible(child: EasyText(status.name.tr(), fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationItem extends HookWidget {
  const _LocationItem({
    required this.location,
    required this.isConnected,
  });

  final bool isConnected;
  final VPNLocation? location;

  @override
  Widget build(BuildContext context) {
    final code = useMemoized(
      () {
        if (location == null || !isConnected) {
          return null;
        }
        return location!.code;
      },
      [location, isConnected],
    );

    return _Item(
      label: LocaleKeys.location.tr(),
      children: [
        EasyText(
          code?.tr() ?? '--',
          maxLines: 2,
          fontSize: 12,
          textAlign: TextAlign.center,
        ),
        if (code != null) Flag(countryCode: code),
      ],
    );
  }
}
