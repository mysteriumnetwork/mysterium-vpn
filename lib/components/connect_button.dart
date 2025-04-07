import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class ConnectButton extends HookConsumerWidget {
  ConnectButton({
    required this.onPressed,
    this.location,
    super.key,
  }) {
    powerOn = location == null ? Assets.powerOn : Assets.nodePowerOn;
    powerOff = location == null ? Assets.powerOff : Assets.nodePowerOff;
    powerConnecting = location == null ? Assets.powerConnecting : Assets.nodePowerOff;
  }

  final VoidCallback onPressed;
  final VPNLocation? location;
  late final String powerOn;
  late final String powerOff;
  late final String powerConnecting;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final controller = useAnimationController(
      duration: const Duration(seconds: 2),
    )..repeat();

    final isConnected = useComputedValue(
      () {
        if (!vpnStore.isConnected) {
          return false;
        }
        if (location == null) {
          return true;
        }

        return location == vpnStore.location;
      },
      [location],
    );

    final isLoading = useComputedValue(
      () {
        if (!vpnStore.isLoading) {
          return false;
        }
        if (location == null) {
          return true;
        }

        return location == vpnStore.connectingLocation;
      },
      [location],
    );

    if (isLoading) {
      return AnimatedBuilder(
        animation: controller,
        builder: (_, child) => Transform.rotate(
          angle: controller.value * 2 * pi,
          child: child,
        ),
        child: SvgIconButton(
          asset: powerConnecting,
          onPressed: () {
            showSnackbar(LocaleKeys.connectingInProggress.tr());
          },
        ),
      ).fittedBox();
    }

    return SvgIconButton(
      asset: isConnected ? powerOn : powerOff,
      onPressed: onPressed,
    );
  }
}
