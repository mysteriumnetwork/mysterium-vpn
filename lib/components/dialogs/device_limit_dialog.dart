import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> showDeviceLimitDialog(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    useSafeArea: false,
    fullscreenDialog: ScreenType.of(context) < ScreenType.desktop,
    builder: (_) {
      if (ScreenType.of(context) >= ScreenType.desktop) {
        return _DesktopDialog();
      }
      return _MobileDialog();
    },
  );
}

class _DesktopDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.palette.connectionTileBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.palette.outlinedButtonBorderColor),
      ),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, minHeight: 400),
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
                child: _Body(isMobile: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog.fullscreen(
      backgroundColor: theme.palette.connectionTileBackgroundColor,
      child: SafeArea(
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
                  _Body(isMobile: true),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    const minButtonSize = Size(164, 48);

    void handleOpenDashboard() {
      launchUrlString(
        Env.manageDevicesPage,
        mode: LaunchMode.externalApplication,
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isMobile) const Spacer(),
        Center(child: Asset.images.devicesLimit.svg(width: 150, height: 150)),
        Text(
          LocaleKeys.deviceLimitReachedTitle.tr(),
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40, top: 16),
          child: Text(
            LocaleKeys.deviceLimitReachedDesc.tr(),
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        if (isMobile) const Spacer(),
        Center(
          child: SizedBox(
            width: isMobile ? double.infinity : null,
            child: ElevatedButton(
              onPressed: handleOpenDashboard,
              style: ElevatedButton.styleFrom(
                minimumSize: minButtonSize,
                backgroundColor: theme.palette.outlinedButtonBorderColor,
              ),
              child: Text(
                LocaleKeys.deviceLimitReachedOpenDashboard.tr(),
                style: GoogleFonts.montserrat(
                  color: Palette.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) => SvgIconButton(
        asset: Asset.icons.close2(context),
        onPressed: Navigator.of(context).pop,
        size: 32,
      );
}
