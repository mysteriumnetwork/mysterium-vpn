// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:vpn_api/vpn_api.dart';

Future<void> showRateConnectionDialog(
  BuildContext context,
  RateConnectionRequestModeEnum mode,
) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final store = RateConnectionStore(
    mode,
    container.read(analyticsStorePOD),
    container.read(vpnStorePOD),
  );

  final future = await showBottomSheetDialog<Future<void>>(
    context,
    mobileConstraints: BoxConstraints(maxHeight: getMediaHeight(context) * 0.95),
    desktopConstraints: const BoxConstraints(maxWidth: 637, maxHeight: 700),
    builder: (ctx) => BottomSheetDialog(
      title: mode == RateConnectionRequestModeEnum.like
          ? S.current.rateConnectionLike
          : S.current.rateConnectionDislike,
      body: _RateConnectionBody(store: store),
      primaryButton: ButtonPrimary(
        onPressed: () => Navigator.of(ctx).pop(store.submitRateConnection()),
        child: Text(S.current.submitBtn),
      ),
      secondaryButton: ButtonSecondary(
        onPressed: () {
          store.cancelRateConnection();
          Navigator.of(ctx).pop();
        },
        child: Text(S.current.cancelBtn),
      ),
    ),
  );
  try {
    await future;
  } catch (_) {
    showSnackbar(S.current.failedToSubmitFeedback);
  }
}

class _RateConnectionBody extends StatelessWidget {
  const _RateConnectionBody({required this.store});

  final RateConnectionStore store;

  String _stringifyReason(RateConnectionReason reason) => switch (reason) {
    RateConnectionReason.accessToSites => S.current.bypassRestrictionsReason,
    RateConnectionReason.unstableSpeed => S.current.unstableSpeedReason,
    RateConnectionReason.stableConnection => S.current.stableConnectionReason,
    RateConnectionReason.other => S.current.otherReason,
    RateConnectionReason.frequentDisconnects => S.current.frequentDisconnectsReason,
    RateConnectionReason.lowLatency => S.current.lowLatencyReason,
    RateConnectionReason.highLatency => S.current.highLatencyReason,
    RateConnectionReason.consistentSpeed => S.current.consistentSpeedReason,
    RateConnectionReason.geoBlockedSites => S.current.accessBlockedSitesReason,
    RateConnectionReason.incorrectLocation => S.current.incorrectLocationReason,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;

    return Observer(
      builder: (context) {
        final selectedReasons = store.selectedReasons;
        final axisCount = ScreenType.of(context) >= ScreenType.tablet ? 2 : 1;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: theme.spacing.xl2,
              children: [
                for (int i = 0; i < store.showReasons.length; i += axisCount)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: theme.spacing.xl2,
                    children: [
                      for (int j = 0; j < axisCount; j++)
                        if (i + j < store.showReasons.length)
                          Expanded(
                            child: CheckboxItem(
                              value: selectedReasons.contains(store.showReasons[i + j]),
                              onChanged: () =>
                                  store.toggleRateConnectionReason(store.showReasons[i + j]),
                              label: Text(
                                _stringifyReason(store.showReasons[i + j]),
                                style: theme.textStyles.textMd.medium,
                              ),
                            ),
                          )
                        else
                          const Expanded(child: SizedBox()),
                    ],
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: theme.spacing.xl2),
              child: TextField(
                maxLines: 4,
                onChanged: (value) => store.feedback = value,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: palette.bgPrimary,
                  contentPadding: const EdgeInsets.all(14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: palette.borderPrimary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: palette.borderBrand),
                  ),
                  hintText: S.current.typeFeedback,
                  hintStyle: theme.textStyles.textMd.regular.copyWith(color: palette.textTertiary),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
