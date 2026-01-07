import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/async_text_button.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class ConnectTextButton extends HookConsumerWidget {
  const ConnectTextButton({
    required this.onPressed,
    required this.location,
    required this.size,
    this.textScaleGroup,
    this.loadingIndicatorRadius = 16,
    this.outlinedButton = false,
    this.borderRadius,
    this.fontStyle,
    this.textConnect,
    this.textDisconnect,
    super.key,
  });

  final VoidCallback? onPressed;
  final VPNLocation? location;
  final AutoSizeGroup? textScaleGroup;
  final Size size;
  final double loadingIndicatorRadius;
  final bool outlinedButton;
  final double? borderRadius;
  final TextStyle? fontStyle;
  final String? textConnect;
  final String? textDisconnect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionFeaturesStore = ref.watch(subscriptionFeaturesStorePOD);
    final unavailableLocationsStore = ref.watch(unavailableLocationsStorePOD);
    final isConnected = useIsLocationConnected(location);
    final textConnect = this.textConnect ?? LocaleKeys.connect.tr();
    final textDisconnect = this.textDisconnect ?? LocaleKeys.disconnect.tr();
    final buttonFallbackMode =
        outlinedButton ? AsyncTextButtonMode.outlined : AsyncTextButtonMode.elevated;
    final handleSubscribe = useHandleSubscribeOrUpgrade();

    void onPressed() {
      this.onPressed?.call();
    }

    return Observer(
      builder: (context) {
        final mode = _Mode.from(
          isConnected: isConnected,
          residentialIPsAllowed: subscriptionFeaturesStore.residentialIPsAllowed,
          location: location,
          unavailableLocations: unavailableLocationsStore.unavailableLocations,
        );
        return AsyncTextButton(
          isLoading: mode == _Mode.connecting,
          minimumSize: size,
          textScaleGroup: textScaleGroup,
          borderRadius: borderRadius == null ? null : BorderRadius.circular(borderRadius!),
          text: switch (mode) {
            _Mode.connecting => LocaleKeys.connecting.tr(),
            _Mode.connected => textDisconnect,
            _Mode.available || _Mode.unavailable => textConnect,
            _Mode.unsupportedByPlan => LocaleKeys.subscriptionUpgrade.tr(),
          },
          mode: switch (mode) {
            _Mode.connected ||
            _Mode.connecting ||
            _Mode.unsupportedByPlan =>
              AsyncTextButtonMode.filled,
            _ => buttonFallbackMode,
          },
          onPressed: switch (mode) {
            _Mode.unavailable => null,
            _Mode.connecting => null,
            _Mode.connected || _Mode.available => onPressed,
            _Mode.unsupportedByPlan => handleSubscribe,
          },
        );
      },
    );
  }
}

enum _Mode {
  connecting,
  connected,
  available,
  unavailable,
  unsupportedByPlan;

  static _Mode from({
    required bool? isConnected,
    required bool residentialIPsAllowed,
    required VPNLocation? location,
    required Iterable<VPNLocation> unavailableLocations,
  }) {
    if (isConnected == null) {
      return _Mode.connecting;
    }
    if (isConnected) {
      return _Mode.connected;
    }
    if (location != null && location.ipType == IPType.residential) {
      if (!residentialIPsAllowed || !location.isAvailable) {
        return _Mode.unsupportedByPlan;
      }
    }
    if (unavailableLocations.contains(location)) {
      return _Mode.unavailable;
    }
    if (location != null && !location.isAvailable) {
      return _Mode.unavailable;
    }
    return _Mode.available;
  }
}
