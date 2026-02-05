import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/utils/design_system_theme.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

Future<void> showPushNotificationsPermissionDialog(BuildContext context) async {
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
    final userPreferencesStore = ref.watch(userPreferencesStorePOD);
    return ModalScaffold(
      showGradient: false,
      showCloseButton: false,
      autoApplyPadding: false,
      body: Padding(
        padding: ModalPadding.insets(
          context,
          add: const EdgeInsets.symmetric(
            vertical: 40,
            horizontal: 40,
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            Asset.images.marketingConsent(context).image(width: 150, height: 150),
            const SizedBox(height: 12),
            Text(
              LocaleKeys.pushNotificationsConsentPopupTitle.tr(),
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              LocaleKeys.pushNotificationsConsentPopupDesc.tr(),
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ).padding(bottom: 24, top: 12),
            const Spacer(),
            ButtonPrimary(
              onPressed: () => _completePushNotificationsFlow(
                context,
                userPreferencesStore: userPreferencesStore,
                userAllowed: true,
              ),
              child: Text(
                LocaleKeys.allowPushNotificationsBtn.tr(),
              ),
            ).width(double.infinity),
            ButtonSecondary(
              onPressed: () => _completePushNotificationsFlow(
                context,
                userPreferencesStore: userPreferencesStore,
                userAllowed: false,
              ),
              child: Text(
                LocaleKeys.notNowBtn.tr(),
              ),
            ).padding(top: 16).width(double.infinity),
          ],
        ),
      ),
    );
  }
}

Future<void> _completePushNotificationsFlow(
  BuildContext context, {
  required UserPreferencesStore userPreferencesStore,
  required bool userAllowed,
}) async {
  await userPreferencesStore.setPushNotificationsShown(userAllowed: userAllowed);

  if (context.mounted) {
    Navigator.of(context).pop();
  }
}
