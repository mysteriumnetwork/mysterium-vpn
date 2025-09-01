import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
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
    final theme = Theme.of(context);
    final authStore = ref.watch(authStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);

    return Observer(
      builder: (context) {
        final signInStatus = authStore.signInFeature.status;

        Future<void> handleResend() async {
          analyticsStore.logEvent(AnalyticsEvent.resendEmailClicked);
          await authStore.signInwithEmail(email: authStore.email!);
        }

        return Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 20,
              children: [
                const _Subheader(),
                if (authStore.email != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: _Email(email: authStore.email!),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _Excerpt(
                    items: [
                      LocaleKeys.linkExpires.tr(),
                      LocaleKeys.consumeLink.tr(),
                    ],
                  ),
                ),
                Visibility(
                  visible: isMobile(),
                  child: EasyButton(
                    color: Palette.purple,
                    useSystemColor: false,
                    text: LocaleKeys.openEmailApp.tr(),
                    onPressed: () {
                      analyticsStore.logEvent(AnalyticsEvent.openEmailClicked);
                      openEmailApp(context, analyticsStore);
                    },
                  ),
                ),
                _ResendButton(
                  onPressed: handleResend,
                  isLoading: signInStatus == FutureStatus.pending,
                ),
              ],
            ).scrollable().padding(
                  top: 20,
                  bottom: 10,
                  horizontal: getMediaWidth(context) > 650 ? 60 : 20,
                ),
            if (authStore.authenticateFeature?.status == FutureStatus.pending)
              LoadingBarrier(color: theme.primaryColor),
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

class _Subheader extends HookWidget {
  const _Subheader();

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      EasyText(
        LocaleKeys.checkYourEmail.tr(),
        fontSize: useResponsiveValue(20, desktop: 28),
        fontWeight: FontWeight.w600,
        textAlign: TextAlign.center,
      ),
      const SvgIcon(asset: Assets.checkEmail),
    ];
    return Column(
      spacing: 30,
      children: useResponsiveValue(children, desktop: children.reversed.toList()),
    );
  }
}

class _Email extends HookWidget {
  const _Email({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final text = LocaleKeys.emailSentTo.tr(namedArgs: {'email': email});
    final label = text.replaceAll(email, '').trim();
    final separator = useResponsiveValue('\n', desktop: ' ');
    return AutoSizeText.rich(
      TextSpan(
        children: [
          TextSpan(text: label),
          TextSpan(text: separator),
          TextSpan(
            text: email,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      maxLines: 2,
      textAlign: TextAlign.center,
      style: GoogleFonts.montserrat(fontSize: 16),
    );
  }
}

class _Excerpt extends StatelessWidget {
  const _Excerpt({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          for (final item in items) _BulletItem(text: item),
        ],
      );
}

class _BulletItem extends StatelessWidget {
  const _BulletItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EasyText('•'),
          const SizedBox(width: 12),
          Expanded(child: EasyText(text, maxLines: 3)),
        ],
      );
}

class _ResendButton extends HookWidget {
  const _ResendButton({
    required this.onPressed,
    required this.isLoading,
  });

  final Future<void> Function() onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timer = useCountdownTimer(initialCountdown: 3);
    final resendDisabled = isLoading || timer.countdown > 0;
    final onPressed = resendDisabled ? null : () => this.onPressed().whenComplete(timer.reset);

    final child = isLoading
        ? LoadingIndicator(indicatorColor: theme.palette.disabledButtonForegroundColor)
        : Text(
            LocaleKeys.sendAgain.plural(timer.countdown),
            style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w700),
          );

    if (isMobile()) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          disabledBackgroundColor: theme.palette.disabledButtonBackgroundColor,
          disabledForegroundColor: theme.palette.disabledButtonForegroundColor,
          side: resendDisabled ? BorderSide.none : null,
          minimumSize: const Size(200, 50),
          backgroundColor: Colors.transparent,
        ),
        child: child,
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: theme.palette.disabledButtonBackgroundColor,
        disabledForegroundColor: theme.palette.disabledButtonForegroundColor,
        minimumSize: const Size(200, 50),
        foregroundColor: theme.palette.filledButtonTextColor,
        backgroundColor: Palette.purple,
      ),
      child: child,
    );
  }
}
