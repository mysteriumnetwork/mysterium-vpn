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
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide ScreenType;
import 'package:vpn_api/vpn_api.dart';

Future<void> showRateConnectionDialog(
  BuildContext context,
  RateConnectionRequestModeEnum mode,
) async {
  final store = RateConnectionStore(
    mode,
    getIt<AnalyticsStore>(),
    getIt<VpnStore>(),
  );

  final future = await showBottomSheetDialog<Future<void>>(
    context,
    mobileConstraints: BoxConstraints(maxHeight: getMediaHeight(context) * 0.95),
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ScreenType.of(context) >= ScreenType.tablet ? 2 : 1,
                mainAxisExtent: 60,
              ),
              itemCount: store.showReasons.length,
              itemBuilder: (context, index) {
                final reason = store.showReasons[index];
                return CheckboxListTile(
                  minVerticalPadding: 0,
                  visualDensity: VisualDensity.compact,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: selectedReasons.contains(reason),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (_) => store.toggleRateConnectionReason(reason),
                  title: Text(_stringifyReason(reason), style: theme.textStyles.textMd.medium),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 32),
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
