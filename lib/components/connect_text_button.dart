import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class ConnectTextButton extends HookConsumerWidget {
  const ConnectTextButton({
    required this.onPressed,
    required this.location,
    this.minimumSize = const Size(120, 40),
    this.textScaleGroup,
    super.key,
  });

  final VoidCallback? onPressed;
  final VPNLocation location;
  final AutoSizeGroup? textScaleGroup;
  final Size minimumSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = useIsLocationConnected(location);

    void onPressed() {
      this.onPressed?.call();
    }

    return switch (isConnected) {
      false => OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(minimumSize: minimumSize),
          child: AutoSizeText(
            LocaleKeys.connect.tr(),
            group: textScaleGroup,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      true => FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(minimumSize: minimumSize),
          child: AutoSizeText(
            LocaleKeys.disconnect.tr(),
            group: textScaleGroup,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      null => SizedBox.fromSize(
          size: minimumSize,
          child: const LoadingIndicator(radius: 20),
        ),
    };
  }
}
