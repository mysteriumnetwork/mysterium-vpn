import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/shared/components/dialogs/rate_connection_dialog.dart';
import 'package:mysterium_vpn/shared/components/easy_text.dart';
import 'package:mysterium_vpn/shared/components/svg_icon_button.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:vpn_api/vpn_api.dart';

class RateConnection extends ConsumerWidget {
  const RateConnection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final connectionDisplayStore = ref.watch(connectionDisplayStorePOD);
    final remoteConfigStore = ref.watch(remoteConfigStorePOD);

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
