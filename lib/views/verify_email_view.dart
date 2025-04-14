import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:mysterium_vpn/components/dialogs/no_mail_app_dialog.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:styled_widget/styled_widget.dart';

class VerifyEmailView extends HookConsumerWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStore = ref.watch(authStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);
    final height = getMediaHeight(context);
    final timer = useCountdownTimer(
      initialCountdown: 5,
    );
    return Observer(
      builder: (context) {
        final signInStatus = authStore.signInFeature.status;
        return Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EasyText(
                  LocaleKeys.checkYourEmail.tr(),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ).padding(bottom: 20),
                const SvgIcon(
                  asset: Assets.checkEmail,
                ).padding(bottom: height * .03),
                EasyText(
                  LocaleKeys.emailSentTo.tr(namedArgs: {'email': '${authStore.email}'}),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ).padding(bottom: height * .02),
                EasyText(
                  LocaleKeys.linkExpires.tr(),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ).padding(bottom: height * .02),
                EasyText(
                  LocaleKeys.consumeLink.tr(),
                  maxLines: 5,
                  textAlign: TextAlign.center,
                ).padding(bottom: height * .05),
                Visibility(
                  visible: isMobile(),
                  child: EasyButton(
                    width: 200,
                    text: LocaleKeys.openEmailApp.tr(),
                    onPressed: () {
                      analyticsStore.logEvent(AnalyticsEvent.openEmailClicked);
                      openEmailApp(context, analyticsStore);
                    },
                  ).padding(
                    bottom: 20,
                  ),
                ),
                EasyButton(
                  width: 200,
                  color: Palette.purple,
                  useSystemColor: false,
                  onPressed: timer.isActive
                      ? null
                      : () async {
                          analyticsStore.logEvent(AnalyticsEvent.resendEmailClicked);
                          authStore
                              .signInwithEmail(email: authStore.email!)
                              .whenComplete(timer.reset);
                        },
                  child: signInStatus == FutureStatus.pending
                      ? const LoadingIndicator(
                          radius: 20,
                          strokeWidth: 1.5,
                          indicatorColor: Palette.white,
                        )
                      : EasyText(
                          LocaleKeys.sendAgain.plural(timer.countdown),
                          color: Palette.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                ),
              ],
            ).scrollable().padding(
                  top: 20,
                  bottom: 10,
                  horizontal: getMediaWidth(context) > 650 ? 60 : 20,
                ),
            if (authStore.authenticateFeature?.status == FutureStatus.pending)
              LoadingBarrier(color: Theme.of(context).primaryColor),
          ],
        );
      },
    );
  }

  Future<void> openEmailApp(
    BuildContext context,
    AnalyticsStore analyticsStore,
  ) async {
    final result = await OpenMailApp.openMailApp(
      nativePickerTitle: LocaleKeys.selectEmailApp.tr(),
    );
    if (!result.didOpen && !result.canOpen && context.mounted) {
      shownNoMailAppDialog(context);
    } else if (!result.didOpen && result.canOpen && context.mounted) {
      final actions = result.options
          .map(
            (option) => BottomSheetAction(
              title: option.name,
              onPressed: (_) {
                OpenMailApp.openSpecificMailApp(option);
                analyticsStore.logEvent(
                  AnalyticsEvent.emailProviderClicked,
                  parameters: {'provider': option.name},
                );
              },
            ),
          )
          .toList();
      showAdaptiveActionSheet(
        title: Text(LocaleKeys.selectEmailApp.tr()),
        context: context,
        actions: [...actions],
        cancelAction: CancelAction(
          title: LocaleKeys.cancelBtn.tr(),
          onPressed: (ctx) {
            analyticsStore.logEvent(AnalyticsEvent.emailProviderCancel);
            Navigator.of(ctx).pop();
          },
        ),
      );
    }
  }
}
