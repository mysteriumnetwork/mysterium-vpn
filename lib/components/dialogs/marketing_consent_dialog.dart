import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/keys.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

Future<void> showMarketingConsentDialog(
  BuildContext context, {
  required bool desktopSize,
}) async =>
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => HookBuilder(
        builder: (context) {
          final isDesktop = useResponsiveValue(false, desktop: true);
          return isDesktop ? _DesktopDialog() : _MobileDialog();
        },
      ),
    );

class _DesktopDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.palette.connectionTileBackgroundColor,
      child: Container(
        width: 600,
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Palette.purple),
        ),
        child: const Stack(
          children: [
            Positioned(
              top: 16,
              right: 16,
              child: _CloseButton(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 32,
                horizontal: 120,
              ),
              child: _DialogContent(isMobile: false),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Dialog.fullscreen(
      backgroundColor: theme.palette.connectionTileBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: const Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: _CloseButton(),
                ),
                _DialogContent(isMobile: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogContent extends ConsumerWidget {
  const _DialogContent({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPreferencesStore = ref.watch(userPreferencesStorePOD);

    Future<void> handleSignMeUp() async {
      await _updateMarketingConsent(context, consent: true);
    }

    return Column(
      key: Keys.marketingConsentDialog,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isMobile) const Spacer(),
        Asset.images.marketingConsent(context).image(width: 150, height: 150),
        Text(
          LocaleKeys.marketingConsentPopupTitle.tr(),
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          LocaleKeys.marketingConsentPopupDesc.tr(),
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ).padding(
          bottom: 40,
          top: 16,
        ),
        if (isMobile) const Spacer(),
        Observer(
          builder: (context) {
            final futureStatus = userPreferencesStore.updateMarketingConsentFuture.status;
            if (futureStatus == FutureStatus.pending) {
              return const LoadingIndicator();
            }
            return Column(
              children: [
                _Actions(
                  onSignMeUpPressed: handleSignMeUp,
                  flexDirection: isMobile ? Axis.vertical : Axis.horizontal,
                ),
                if (futureStatus == FutureStatus.rejected)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      LocaleKeys.somethingWentWrong.tr(),
                      style: const TextStyle(
                        color: Palette.crimsonRed,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    Future<void> handleCancel() async {
      await _updateMarketingConsent(context, consent: false);
    }

    return SvgIconButton(
      asset: Asset.icons.close2(context),
      onPressed: handleCancel,
      size: 32,
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.flexDirection,
    required this.onSignMeUpPressed,
  });

  final VoidCallback? onSignMeUpPressed;
  final Axis flexDirection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const minButtonSize = Size(164, 48);

    final children = <Widget>[
      ElevatedButton(
        key: Keys.marketingConsentAcceptButton,
        style: ElevatedButton.styleFrom(
          minimumSize: minButtonSize,
          backgroundColor: theme.palette.outlinedButtonBorderColor,
        ),
        onPressed: onSignMeUpPressed,
        child: Text(
          LocaleKeys.signMeUpBtn.tr(),
          style: GoogleFonts.montserrat(
            color: Palette.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    ];

    return Flex(
      mainAxisSize: MainAxisSize.min,
      direction: flexDirection,
      spacing: 20,
      crossAxisAlignment: switch (flexDirection) {
        Axis.vertical => CrossAxisAlignment.stretch,
        Axis.horizontal => CrossAxisAlignment.center,
      },
      children: [
        ...switch (flexDirection) {
          Axis.vertical => children,
          Axis.horizontal => children.reversed,
        },
      ],
    );
  }
}

Future<void> _updateMarketingConsent(
  BuildContext context, {
  required bool consent,
}) async {
  await ProviderScope.containerOf(context, listen: false)
      .read(userPreferencesStorePOD)
      .updateMarketingContact(
        consent: consent,
        fromPopup: true,
      );

  if (context.mounted) {
    Navigator.of(context).pop();
  }
}
