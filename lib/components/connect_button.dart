import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

// TODO(kristijan): Add correct svg asset for the connect button
class ConnectButton extends HookConsumerWidget {
  ConnectButton({
    required this.onPressed,
    this.locationCode,
    super.key,
  }) {
    powerOn = locationCode == null ? Assets.powerOn : Assets.nodePowerOn;
    powerOff = locationCode == null ? Assets.powerOff : Assets.nodePowerOff;
    powerConnecting = locationCode == null ? Assets.powerConnecting : Assets.nodePowerOff;
  }

  final VoidCallback onPressed;
  final String? locationCode;
  late final String powerOn;
  late final String powerOff;
  late final String powerConnecting;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final controller = useAnimationController(
      duration: const Duration(seconds: 10),
    )..repeat();
    return Observer(
      builder: (context) => vpnStore.isLoading &&
              (locationCode == vpnStore.connectingLocationCode || locationCode == null)
          ? AnimatedBuilder(
              animation: controller,
              builder: (_, child) => Transform.rotate(
                angle: controller.value * 40,
                child: child,
              ),
              child: SvgIconButton(
                asset: powerConnecting,
                onPressed: onPressed,
              ),
            ).fittedBox()
          : SvgIconButton(
              asset: vpnStore.isConnected ? powerOn : powerOff,
              onPressed: onPressed,
            ).fittedBox(),
    );
  }
}
