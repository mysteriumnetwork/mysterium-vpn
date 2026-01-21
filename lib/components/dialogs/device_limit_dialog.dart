import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/design_system_theme.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> showDeviceLimitDialog(BuildContext context) async {
  await showModal(
    context,
    builder: (_) => Theme(
      data: DesignSystemTheme.of(context),
      child: const _DialogContent(),
    ),
  );
}

class _DialogContent extends ConsumerWidget {
  const _DialogContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sessionStore = ref.watch(authSessionStorePOD);

    void handleOpenDashboard() {
      final uri = Uri.parse(Env.manageDevicesPage);
      final accessToken = sessionStore.accessToken;
      final queryParameters = (accessToken?.isNotEmpty ?? false)
          ? {
              ...uri.queryParameters,
              'access_token': accessToken,
            }
          : null;
      final targetUri = Uri(
        scheme: uri.scheme,
        host: uri.host,
        path: uri.path,
        queryParameters: queryParameters,
      );
      openUrlLink(
        targetUri,
        mode: LaunchMode.externalApplication,
      );
    }

    return ModalScaffold(
      autoApplyPadding: false,
      body: Padding(
        padding: ModalPadding.insets(
          context,
          add: EdgeInsets.symmetric(
            vertical: theme.spacing.xl,
            horizontal: theme.spacing.md,
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
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
            const Spacer(),
            ButtonPrimary(
              onPressed: handleOpenDashboard,
              child: Text(
                LocaleKeys.deviceLimitReachedOpenDashboard.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
