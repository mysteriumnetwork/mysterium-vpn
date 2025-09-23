// ignore_for_file: use_build_context_synchronously

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/enums/rate_connection.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/rate_connection_store.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:vpn_api/vpn_api.dart';

Future<void> showRateConnectionDialog(
  BuildContext context,
  RateConnectionRequestModeEnum mode,
) =>
    showDialog(
      context: context,
      builder: (context) => _ConfirmDialog(mode),
    );

class _ConfirmDialog extends HookConsumerWidget {
  const _ConfirmDialog(
    this.rateConnectionMode,
  );

  final RateConnectionRequestModeEnum rateConnectionMode;

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
        RateConnectionReason.incorrectLocation => LocaleKeys.incorrectLocationReason.tr(),
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rateConnectionStore = useMemoized(
      () => RateConnectionStore(
        rateConnectionMode,
        ref.read(analyticsStorePOD),
        ref.read(apiServicePOD),
        ref.read(vpnStorePOD),
      ),
    );
    final brightness = Theme.of(context).brightness;
    final screenType = useScreenType();

    return Observer(
      builder: (context) {
        final futureStatus = rateConnectionStore.submitRateConnectionFuture?.status;
        final futureStatusPending = futureStatus == FutureStatus.pending;
        final futureStatusError = futureStatus == FutureStatus.rejected;
        final futureStatusFulfilled = futureStatus == FutureStatus.fulfilled;
        return AlertDialog(
          scrollable: true,
          buttonPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          titlePadding: EdgeInsets.only(
            top: futureStatusFulfilled ? 0 : 30,
            left: 20,
            right: 20,
            bottom: 30,
          ),
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(horizontal: 15),
          iconPadding: const EdgeInsets.only(top: 30, bottom: 20),
          backgroundColor: getDialogBackgroundColor(brightness),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          icon: futureStatusFulfilled ? SvgIcon(asset: Asset.icons.feedback) : null,
          title: Text(
            futureStatusFulfilled
                ? LocaleKeys.thanksForFeedback.tr()
                : rateConnectionStore.isLikeMode
                    ? LocaleKeys.rateConnectionLike.tr()
                    : LocaleKeys.rateConnectionDislike.tr(),
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: getDialogTextColor(brightness),
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            if (futureStatusFulfilled)
              TextButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(Palette.purple),
                ),
                child: Text(
                  LocaleKeys.closeBtn.tr(),
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ).height(80)
            else ...[
              if (futureStatusPending)
                const LoadingIndicator().height(80)
              else ...[
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(
                      cancelButtonColor(brightness),
                    ),
                  ),
                  child: Text(
                    LocaleKeys.cancelBtn.tr(),
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    rateConnectionStore.cancelRateConnection();
                  },
                ),
                VerticalDivider(
                  width: 1,
                  color: getDialogTextColor(brightness).withValues(alpha: .2),
                ).height(80),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Palette.purple),
                  ),
                  onPressed: rateConnectionStore.submitRateConnection,
                  child: Text(
                    LocaleKeys.submitBtn.tr(),
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ],
          content: SizedBox(
            width: switch (screenType) {
              ScreenType.mobile => getMediaWidth(context) > 335 ? 335 : double.infinity,
              _ => 335,
            },
            child: Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (futureStatusFulfilled)
                      Text(
                        LocaleKeys.thanksForFeedbackDesc.tr(),
                        style: GoogleFonts.montserrat(
                          color: getDialogTextColor(brightness),
                        ),
                        textAlign: TextAlign.center,
                      )
                    else ...[
                      ...rateConnectionStore.showReasons.mapIndexed(
                        (i, element) => CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          side: BorderSide(
                            color: Theme.of(context).tabBarTheme.indicatorColor ?? Palette.purple,
                          ),
                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          value: rateConnectionStore.selectedReasons.contains(
                            rateConnectionStore.showReasons[i],
                          ),
                          fillColor: WidgetStateProperty.resolveWith(
                            (states) {
                              if (states.contains(WidgetState.selected)) {
                                return Palette.purple;
                              }
                              return Palette.lightBlue;
                            },
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
                            style: GoogleFonts.montserrat(
                              color: getDialogTextColor(brightness),
                            ),
                          ),
                        ),
                      ),
                      TextField(
                        maxLines: 2,
                        cursorColor: Palette.purple,
                        onChanged: (value) {
                          rateConnectionStore.feedback = value;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).colorScheme.secondaryContainer,
                          contentPadding: const EdgeInsets.all(12),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide.none,
                          ),
                          hintText: LocaleKeys.typeFeedback.tr(),
                          hintStyle: GoogleFonts.montserrat(
                            color: getDialogTextColor(brightness).withValues(alpha: .5),
                          ),
                        ),
                      ),
                      if (futureStatusError)
                        Text(
                          LocaleKeys.failedToSubmitFeedback.tr(),
                          style: GoogleFonts.montserrat(
                            color: Palette.crimsonRed,
                          ),
                        ).padding(top: 10),
                    ],
                  ],
                ).padding(
                  left: 20,
                  right: 20,
                ),
                Divider(
                  height: 1,
                  color: getDialogTextColor(brightness).withValues(alpha: .2),
                ).padding(top: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
