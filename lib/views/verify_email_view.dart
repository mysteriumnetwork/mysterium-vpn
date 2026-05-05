import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:open_mail_app/open_mail_app.dart';

class VerifyEmailView extends HookConsumerWidget {
  const VerifyEmailView({super.key});

  static const double _maxContentWidth = 360;
  static const double _mobileTopGap = 56;
  static const double _mobileBottomGap = 32;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.spacing;
    final palette = theme.palette;
    final authStore = ref.read(authStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;

    return Observer(
      builder: (context) {
        final signInStatus = authStore.signInFeature.status;

        Future<void> handleResend() async {
          analyticsStore.logEvent(AnalyticsEvent.resendEmailClicked);
          await authStore.signInwithEmail(email: authStore.email!);
        }

        Future<void> handleOpenEmailApp() async {
          analyticsStore.logEvent(AnalyticsEvent.openEmailClicked);
          await openEmailApp(context, analyticsStore);
        }

        final upper = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _MailIcon(),
            SizedBox(height: spacing.xl2),
            Text(
              LocaleKeys.checkYourEmail.tr(),
              textAlign: TextAlign.center,
              style: theme.textStyles.displayXlg.semibold.copyWith(color: palette.textPrimary),
            ),
            SizedBox(height: spacing.xl3),
            if (authStore.email != null) _EmailMessage(email: authStore.email!),
            SizedBox(height: spacing.s),
            _Bullets(items: [LocaleKeys.linkExpires.tr(), LocaleKeys.consumeLink.tr()]),
          ],
        );

        final actions = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ButtonPrimary(
              onPressed: signInStatus == FutureStatus.pending ? null : handleOpenEmailApp,
              decoration: const ButtonDecoration(minimumSize: Size(double.infinity, 44)),
              child: Text(LocaleKeys.openEmailApp.tr()),
            ),
            SizedBox(height: spacing.s),
            _ResendButton(onPressed: handleResend, isLoading: signInStatus == FutureStatus.pending),
          ],
        );

        final body = isDesktop
            ? _DesktopLayout(
                maxWidth: _maxContentWidth,
                gap: spacing.xl3,
                upper: upper,
                actions: actions,
              )
            : _MobileLayout(
                hPad: spacing.md,
                topGap: _mobileTopGap,
                bottomGap: _mobileBottomGap,
                upper: upper,
                actions: actions,
              );

        return Stack(
          children: [
            Column(
              children: [
                const UnauthenticatedHeader(),
                Expanded(child: body),
              ],
            ),
            if (authStore.authenticateFeature?.status == FutureStatus.pending)
              LoadingBarrier(color: palette.bgPopover),
          ],
        );
      },
    );
  }

  Future<void> openEmailApp(BuildContext context, AnalyticsStore analyticsStore) async {
    final result = await OpenMailApp.openMailApp(nativePickerTitle: LocaleKeys.selectEmailApp.tr());
    if (!result.didOpen && !result.canOpen && context.mounted) {
      shownConfirmationDialog(
        context,
        type: AlertModalType.info,
        title: LocaleKeys.openEmailApp.tr(),
        supportingText: LocaleKeys.noEmailApp.tr(),
        showCancel: false,
        confirmText: LocaleKeys.goBackButton.tr(),
        onConfirm: () {},
      );
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

/// 1:2 top/bottom Spacer ratio anchors the block ~1/3 from the top — gives the
/// Figma 75/154 split below the 64px header on a 699-tall window.
class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.maxWidth,
    required this.gap,
    required this.upper,
    required this.actions,
  });

  final double maxWidth;
  final double gap;
  final Widget upper;
  final Widget actions;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const Spacer(),
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            upper,
            SizedBox(height: gap),
            actions,
          ],
        ),
      ),
      const Spacer(flex: 2),
    ],
  );
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.hPad,
    required this.topGap,
    required this.bottomGap,
    required this.upper,
    required this.actions,
  });

  final double hPad;
  final double topGap;
  final double bottomGap;
  final Widget upper;
  final Widget actions;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(hPad, topGap, hPad, 0),
          child: upper,
        ),
      ),
      Padding(padding: EdgeInsets.fromLTRB(hPad, 0, hPad, bottomGap), child: actions),
    ],
  );
}

class _MailIcon extends StatelessWidget {
  const _MailIcon();

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).palette;
    return Center(
      child: DecoratedIcon(
        icon: UntitledUI.mail_05,
        decoration: IconDecoration(
          iconSize: 32,
          iconColor: palette.iconBrandPrimary,
          backgroundColor: palette.bgSecondarySelected,
          padding: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}

class _EmailMessage extends StatelessWidget {
  const _EmailMessage({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final base = theme.textStyles.textMd.regular.copyWith(color: palette.textTertiary);
    final emphasised = theme.textStyles.textSm.bold.copyWith(color: palette.textPrimary);
    final text = LocaleKeys.emailSentTo.tr(namedArgs: {'email': email});
    final label = text.replaceAll(email, '').trim();

    return RichText(
      text: TextSpan(
        style: base,
        children: [
          TextSpan(text: '$label '),
          TextSpan(text: email, style: emphasised),
        ],
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  const _Bullets({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final style = theme.textStyles.textMd.regular.copyWith(color: palette.textTertiary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: EdgeInsets.only(top: theme.spacing.s),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: theme.spacing.s, right: theme.spacing.ms),
                  child: Text('•', style: style),
                ),
                Expanded(child: Text(item, style: style)),
              ],
            ),
          ),
      ],
    );
  }
}

class _ResendButton extends HookWidget {
  const _ResendButton({required this.onPressed, required this.isLoading});

  final Future<void> Function() onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final timer = useCountdownTimer(initialCountdown: 60);
    final disabled = isLoading || timer.countdown > 0;
    final tap = disabled ? null : () => onPressed().whenComplete(timer.reset);

    return ButtonSecondary(
      onPressed: tap,
      loading: isLoading ? const ButtonLoading() : null,
      decoration: const ButtonDecoration(minimumSize: Size(double.infinity, 44)),
      child: Text(LocaleKeys.sendAgain.plural(timer.countdown)),
    );
  }
}
