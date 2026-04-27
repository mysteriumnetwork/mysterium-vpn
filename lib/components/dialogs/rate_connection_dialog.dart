// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/vpn/store/rate_connection_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:vpn_api/vpn_api.dart';

Future<void> showRateConnectionDialog(
  BuildContext context,
  RateConnectionRequestModeEnum mode,
) async {
  final store = RateConnectionStore(mode, getIt<AnalyticsStore>(), getIt<VpnStore>());

  final future = await showBottomSheetDialog<Future<void>>(
    context,
    mobileConstraints: BoxConstraints(maxHeight: getMediaHeight(context) * 0.95),
    desktopConstraints: const BoxConstraints(maxWidth: 637, maxHeight: 700),
    builder: (ctx) => BottomSheetDialog(
      title: mode == RateConnectionRequestModeEnum.like
          ? LocaleKeys.rateConnectionLike.tr()
          : LocaleKeys.rateConnectionDislike.tr(),
      body: _RateConnectionBody(store: store),
      primaryButton: ButtonPrimary(
        onPressed: () => Navigator.of(ctx).pop(store.submitRateConnection()),
        child: Text(LocaleKeys.submitBtn.tr()),
      ),
      secondaryButton: ButtonSecondary(
        onPressed: () {
          store.cancelRateConnection();
          Navigator.of(ctx).pop();
        },
        child: Text(LocaleKeys.cancelBtn.tr()),
      ),
    ),
  );
  try {
    await future;
  } catch (_) {
    showSnackbar(LocaleKeys.failedToSubmitFeedback.tr());
  }
}

class _RateConnectionBody extends StatelessWidget {
  const _RateConnectionBody({required this.store});

  final RateConnectionStore store;

  String _stringifyReason(RateConnectionReason reason) => switch (reason) {
    RateConnectionReason.accessToSites => LocaleKeys.bypassRestrictionsReason.tr(),
    RateConnectionReason.unstableSpeed => LocaleKeys.unstableSpeedReason.tr(),
    RateConnectionReason.stableConnection => LocaleKeys.stableConnectionReason.tr(),
    RateConnectionReason.other => LocaleKeys.otherReason.tr(),
    RateConnectionReason.frequentDisconnects => LocaleKeys.frequentDisconnectsReason.tr(),
    RateConnectionReason.lowLatency => LocaleKeys.lowLatencyReason.tr(),
    RateConnectionReason.highLatency => LocaleKeys.highLatencyReason.tr(),
    RateConnectionReason.consistentSpeed => LocaleKeys.consistentSpeedReason.tr(),
    RateConnectionReason.geoBlockedSites => LocaleKeys.accessBlockedSitesReason.tr(),
    RateConnectionReason.incorrectLocation => LocaleKeys.incorrectLocationReason.tr(),
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
                  hintText: LocaleKeys.typeFeedback.tr(),
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
