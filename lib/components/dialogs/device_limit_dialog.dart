import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide ScreenType;
import 'package:url_launcher/url_launcher_string.dart';

Future<void> showDeviceLimitDialog(BuildContext context) async {
  await showModal(context, builder: (_) => const _DialogContent());
}

class _DialogContent extends StatelessWidget {
  const _DialogContent();

  @override
  Widget build(BuildContext context) {
    final sessionStore = getIt<AuthSessionStore>();
    final palette = Theme.of(context).palette;
    final screenType = getScreenType(MediaQuery.sizeOf(context));
    void handleOpenDashboard() {
      final uri = Uri.parse(Env.manageDevicesPage);
      final accessToken = sessionStore.accessToken;
      final queryParameters = (accessToken?.isNotEmpty ?? false)
          ? {...uri.queryParameters, 'access_token': accessToken}
          : null;
      final targetUri = Uri(
        scheme: uri.scheme,
        host: uri.host,
        path: uri.path,
        queryParameters: queryParameters,
      );
      openUrlLink(targetUri, mode: LaunchMode.externalApplication);
    }

    return PromptDialog(
      image: Asset.images.devicesLimit.svg(),
      title: LocaleKeys.deviceLimitReachedTitle.tr(),
      subtitle: LocaleKeys.deviceLimitReachedDesc.tr(),
      contentPadding: EdgeInsets.symmetric(horizontal: screenType == ScreenType.mobile ? 24 : 144),
      buttonsPadding: EdgeInsets.fromLTRB(
        screenType == ScreenType.mobile ? 16 : 144,
        0,
        screenType == ScreenType.mobile ? 16 : 144,
        50,
      ),
      primaryButton: ButtonPrimary(
        onPressed: handleOpenDashboard,
        child: Text(LocaleKeys.deviceLimitReachedOpenDashboard.tr()),
      ),
      secondaryButton: ButtonSecondary(
        decoration: ButtonDecoration(
          borderColor: palette.borderBrandSecondary,
          foregroundColor: palette.textSecondary,
          decorationColor: Palette.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
        child: Text(LocaleKeys.closeBtn.tr()),
      ),
    );
  }
}
