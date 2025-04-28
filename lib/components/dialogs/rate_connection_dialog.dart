// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/rate_connection.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

Future<void> showRateConnectionDialog(
  BuildContext context,
) =>
    showDialog(
      context: context,
      builder: (context) => const _ConfirmDialog(),
    );

class _ConfirmDialog extends HookConsumerWidget {
  const _ConfirmDialog();

  Color getDialogBackgroundColor(Brightness brightness) => switch (brightness) {
        Brightness.light => Palette.white,
        Brightness.dark => Palette.darkIndigo,
      };
  Color getDialogTextColor(Brightness brightness) => switch (brightness) {
        Brightness.light => Palette.darkIndigo,
        Brightness.dark => Palette.white,
      };

  Color cancelButtonColor(Brightness brightness) => switch (brightness) {
        Brightness.light => Palette.lightBlack,
        Brightness.dark => Palette.lightBlue,
      };

  Color tileTextColor(Brightness brightness) => switch (brightness) {
        Brightness.light => Palette.darkIndigo,
        Brightness.dark => Palette.black,
      };

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
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rateConnectionStore = ref.watch(rateConnectionStorePOD);
    final brightness = Theme.of(context).brightness;

    return Observer(
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        titlePadding: EdgeInsets.only(
          top: rateConnectionStore.isSubmitted ? 0 : 30,
          left: 16,
          right: 16,
        ),
        contentPadding: EdgeInsets.only(
          top: rateConnectionStore.isSubmitted ? 16 : 30,
          bottom: 30,
          left: 16,
          right: 16,
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 15),
        iconPadding: const EdgeInsets.only(top: 30, bottom: 20),
        backgroundColor: getDialogBackgroundColor(brightness),
        actionsAlignment: MainAxisAlignment.spaceAround,
        icon: rateConnectionStore.isSubmitted
            ? const SvgIcon(
                asset: Assets.feedback,
              )
            : null,
        title: Text(
          rateConnectionStore.isSubmitted
              ? LocaleKeys.thanksForFeedback.tr()
              : rateConnectionStore.isLikeMode
                  ? LocaleKeys.rateConnectionLike.tr()
                  : LocaleKeys.rateConnectionDislike.tr(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: getDialogTextColor(brightness),
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          if (rateConnectionStore.isSubmitted)
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Palette.purple),
              ),
              child: Text(
                LocaleKeys.closeBtn.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          else ...[
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(
                  cancelButtonColor(brightness),
                ),
              ),
              child: Text(
                LocaleKeys.cancelBtn.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                rateConnectionStore.cancelRateConnection();
              },
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Palette.purple),
              ),
              onPressed: rateConnectionStore.submitRateConnection,
              child: Text(
                LocaleKeys.submitBtn.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
        content: SizedBox(
          width: getMediaWidth(context) > 750 ? 500 : 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (rateConnectionStore.isSubmitted)
                Text(
                  LocaleKeys.thanksForFeedbackDesc.tr(),
                  style: TextStyle(
                    color: getDialogTextColor(brightness),
                  ),
                  textAlign: TextAlign.center,
                )
              else ...[
                for (var i = 0; i < rateConnectionStore.showReasons.length; i++)
                  CheckboxListTile(
                    value: rateConnectionStore.selectedReasons.contains(
                      rateConnectionStore.showReasons[i],
                    ),
                    fillColor: WidgetStateProperty.all(
                      Palette.purple,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (_) {
                      rateConnectionStore.toggleRateConnectionReason(
                        rateConnectionStore.showReasons[i],
                      );
                    },
                    title: Text(
                      _stringifyReason(
                        rateConnectionStore.showReasons[i],
                      ),
                      style: TextStyle(
                        color: getDialogTextColor(brightness),
                      ),
                    ),
                  ),
                TextField(
                  maxLines: 2,
                  cursorColor: Palette.purple,
                  onChanged: (value) {
                    rateConnectionStore.feedback = value;
                  },
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).colorScheme.secondaryContainer,
                    contentPadding: const EdgeInsets.all(12),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide.none,
                    ),
                    hintText: LocaleKeys.typeFeedback.tr(),
                    hintStyle: TextStyle(
                      color: getDialogTextColor(brightness).withValues(alpha: .5),
                    ),
                  ),
                ),
              ],
              Divider(
                height: 1,
                color: getDialogTextColor(brightness).withValues(alpha: .2),
              ).padding(top: 30),
            ],
          ),
        ),
      ),
    );
  }
}
