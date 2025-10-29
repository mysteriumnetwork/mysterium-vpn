import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/vpn_connection_status.dart';
import 'package:mysterium_vpn/common/hooks/connection_status_color_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class ConnectionStatusBar extends HookConsumerWidget {
  const ConnectionStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final horizontalPadding = useResponsiveValue<double>(
      20,
      tablet: 30,
      desktop: 40,
    );

    final vpnStore = ref.watch(vpnStorePOD);
    final connectionStatus = useComputedValue(() => vpnStore.vpnStatus);
    final isFetchingConfig = useComputedValue(() => vpnStore.isFetchingConfig);
    final isExpanded = useState(false);
    final statusColor = useConnectionStatusColor();

    final handleToggleExpanded = useMemoized(
      () {
        if (connectionStatus != VpnConnectionStatus.connected) {
          return null;
        }
        return () => isExpanded.value = !isExpanded.value;
      },
      [connectionStatus, isExpanded],
    );

    useReaction(
      () => vpnStore.vpnStatus,
      (_) => isExpanded.value = false,
      keys: [isExpanded],
    );

    return RawMaterialButton(
      onPressed: handleToggleExpanded,
      elevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      focusElevation: 0,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      fillColor: statusColor,
      splashColor: Palette.white.withValues(alpha: .2),
      visualDensity: VisualDensity.compact,
      clipBehavior: Clip.antiAlias,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Stack(
                children: [
                  Row(
                    spacing: 6,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _statusIcon(connectionStatus, isFetchingConfig),
                      Flexible(
                        child: EasyText(
                          _statusText(connectionStatus, isFetchingConfig),
                          color: Palette.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  if (handleToggleExpanded != null)
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: _ToggleExpandIndicator(value: isExpanded.value),
                      ),
                    ),
                ],
              ),
            ),
            AnimatedSize(
              alignment: Alignment.topCenter,
              duration: const Duration(milliseconds: 150),
              child: !isExpanded.value ? const SizedBox.shrink() : const _Expanded(),
            ),
          ],
        ),
      ),
    );
  }

  String _statusText(
    VpnConnectionStatus connectionStatus,
    bool isLoading,
  ) {
    if (isLoading) {
      return LocaleKeys.gettingIPAddress.tr();
    }
    return switch (connectionStatus) {
      VpnConnectionStatus.connected => LocaleKeys.connected.tr(),
      VpnConnectionStatus.connecting => LocaleKeys.connecting.tr(),
      VpnConnectionStatus.disconnected => LocaleKeys.disconnected.tr(),
      VpnConnectionStatus.disconnecting => LocaleKeys.disconnecting.tr(),
      VpnConnectionStatus.unknown => '',
    };
  }

  Widget _statusIcon(VpnConnectionStatus connectionStatus, bool isLoading) {
    if (isLoading) {
      return const LoadingIndicator(radius: 16);
    }
    return switch (connectionStatus) {
      VpnConnectionStatus.connected => SvgIcon(
          asset: Asset.icons.killSwitch,
          height: 16,
          width: 16,
        ),
      VpnConnectionStatus.disconnected => SvgIcon(
          asset: Asset.icons.lockOpen,
          height: 14,
          width: 16,
        ),
      VpnConnectionStatus.connecting => const LoadingIndicator(radius: 16),
      VpnConnectionStatus.disconnecting => const LoadingIndicator(radius: 16),
      _ => const SizedBox.shrink(),
    };
  }
}

class _ToggleExpandIndicator extends HookWidget {
  const _ToggleExpandIndicator({
    required this.value,
  });

  final bool value;

  @override
  Widget build(BuildContext context) => AnimatedRotation(
        turns: value ? 0.25 : 0.75,
        duration: const Duration(milliseconds: 200),
        child: const Icon(Icons.chevron_left, color: Palette.white),
      );
}

class _Expanded extends StatelessWidget {
  const _Expanded();

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: .75,
        child: DefaultTextStyle(
          style: GoogleFonts.montserrat(
            color: Palette.white,
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                const Divider(height: 1),
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${LocaleKeys.killSwitchTooltipTitle.tr()}:'),
                    Flexible(
                      child: Text(
                        LocaleKeys.killSwitchTooltipMessage.tr(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
