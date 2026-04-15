import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:styled_widget/styled_widget.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authStore = getIt<AuthStore>();
    final analyticsStore = getIt<AnalyticsStore>();

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 20,
              children: [
                const _Subheader(),
                if (authStore.email != null) Flexible(child: _Email(email: authStore.email!)),
                Expanded(
                  flex: 2,
                  child: _Excerpt(
                    items: [LocaleKeys.linkExpires.tr(), LocaleKeys.consumeLink.tr()],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 20,
                  children: [
                    Flexible(
                      child: Visibility(
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
                    ),
                    Flexible(
                      child: _ResendButton(
                        onPressed: handleResend,
                        isLoading: signInStatus == FutureStatus.pending,
                      ),
                    ),
                  ],
                ),
              ],
            ).padding(vertical: 20, horizontal: getMediaWidth(context) > 650 ? 60 : 20),
            if (authStore.authenticateFeature?.status == FutureStatus.pending)
              LoadingBarrier(color: theme.primaryColor),
          ],
        );
      },
    );
  }

  Future<void> openEmailApp(BuildContext context, AnalyticsStore analyticsStore) async {
    final result = await OpenMailApp.openMailApp(nativePickerTitle: LocaleKeys.selectEmailApp.tr());
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

class _Subheader extends StatelessWidget {
  const _Subheader();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final screenType = getScreenType(MediaQuery.sizeOf(context));
    final fontSize = screenType >= ScreenType.desktop ? 28.0 : 20.0;
    final children = <Widget>[
      Flexible(
        child: EasyText(
          LocaleKeys.checkYourEmail.tr(),
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),
      ),
      SvgIcon(asset: Asset.images.checkEmail, height: min(120, height * .15)),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 30,
      children: screenType >= ScreenType.desktop ? children.reversed.toList() : children,
    );
  }
}

class _Email extends StatelessWidget {
  const _Email({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final text = LocaleKeys.emailSentTo.tr(namedArgs: {'email': email});
    final label = text.replaceAll(email, '').trim();
    final screenType = getScreenType(MediaQuery.sizeOf(context));
    final separator = screenType >= ScreenType.desktop ? ' ' : '\n';
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

class _Excerpt extends StatefulWidget {
  const _Excerpt({required this.items});

  final List<String> items;

  @override
  State<_Excerpt> createState() => _ExcerptState();
}

class _ExcerptState extends State<_Excerpt> {
  final _sizeGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    spacing: 8,
    children: [for (final item in widget.items) _BulletItem(text: item, sizeGroup: _sizeGroup)],
  );
}

class _BulletItem extends StatelessWidget {
  const _BulletItem({required this.text, required this.sizeGroup});

  final String text;
  final AutoSizeGroup sizeGroup;

  @override
  Widget build(BuildContext context) => Flexible(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EasyText('•', autoSizeGroup: sizeGroup),
        const SizedBox(width: 12),
        Expanded(child: EasyText(text, maxLines: 3, autoSizeGroup: sizeGroup)),
      ],
    ),
  );
}

class _ResendButton extends StatefulWidget {
  const _ResendButton({required this.onPressed, required this.isLoading});

  final Future<void> Function() onPressed;
  final bool isLoading;

  @override
  State<_ResendButton> createState() => _ResendButtonState();
}

class _ResendButtonState extends State<_ResendButton> {
  int _countdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() => _countdown--);
      } else {
        if (_countdown == 1) {
          setState(() => _countdown = 0);
        }
        timer.cancel();
      }
    });
  }

  void _reset() {
    setState(() => _countdown = 60);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resendDisabled = widget.isLoading || _countdown > 0;
    final onPressed = resendDisabled ? null : () => widget.onPressed().whenComplete(_reset);

    final child = widget.isLoading
        ? LoadingIndicator(indicatorColor: theme.palette.disabledButtonForegroundColor)
        : Text(
            LocaleKeys.sendAgain.plural(_countdown),
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
