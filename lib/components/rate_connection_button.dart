import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/vpn/store/connection_display_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:vpn_api/vpn_api.dart';

class RateConnection extends StatelessWidget {
  const RateConnection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final connectionDisplayStore = getIt<ConnectionDisplayStore>();
    final remoteConfigStore = getIt<RemoteConfigStore>();

    return Observer(
      builder: (context) {
        if (!connectionDisplayStore.isConnected || !remoteConfigStore.isRateConnectionAvailable) {
          return const SizedBox.shrink();
        }

        return Row(
          spacing: 16,
          children: [
            Expanded(
              child: EasyText(
                LocaleKeys.rateConnection.tr(),
                color: theme.palette.subtitleColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            _RateConnectionIconBtn(
              connectionRated: connectionDisplayStore.connectionRated,
              rateConnectionMode: RateConnectionRequestModeEnum.like,
            ),
            _RateConnectionIconBtn(
              connectionRated: connectionDisplayStore.connectionRated,
              rateConnectionMode: RateConnectionRequestModeEnum.dislike,
            ),
          ],
        );
      },
    );
  }
}

class _RateConnectionIconBtn extends StatelessWidget {
  const _RateConnectionIconBtn({required this.connectionRated, required this.rateConnectionMode});

  final RateConnectionRequestModeEnum rateConnectionMode;
  final RateConnectionRequestModeEnum? connectionRated;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = connectionRated == rateConnectionMode;

    return SvgIconButton(
      asset: switch (rateConnectionMode) {
        RateConnectionRequestModeEnum.like => Asset.icons.thumbsUp(context),
        RateConnectionRequestModeEnum.dislike => Asset.icons.thumbsDown(context),
      },
      color: isActive ? Palette.purple : theme.palette.darkTextColor,
      visualDensity: VisualDensity.compact,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      size: 24,
      onPressed: () => handleRateConnection(context, rateConnectionMode),
    );
  }

  Future<void> handleRateConnection(
    BuildContext context,
    RateConnectionRequestModeEnum rateConnectionMode,
  ) async {
    showRateConnectionDialog(context, rateConnectionMode);
  }
}
