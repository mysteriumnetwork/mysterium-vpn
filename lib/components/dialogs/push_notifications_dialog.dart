import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/features/settings/store/user_preferences_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> showPushNotificationsPermissionDialog(BuildContext context) async {
  await showModal(context, builder: (_) => const _DialogContent());
}

class _DialogContent extends StatelessWidget {
  const _DialogContent();

  @override
  Widget build(BuildContext context) {
    final userPreferencesStore = getIt<UserPreferencesStore>();
    final screenType = ScreenType.of(context);
    return PromptDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: screenType == ScreenType.mobile ? 24 : 144),
      buttonsPadding: EdgeInsets.fromLTRB(
        screenType == ScreenType.mobile ? 16 : 144,
        0,
        screenType == ScreenType.mobile ? 16 : 144,
        50,
      ),
      image: Asset.images.pnConsent(context).image(),
      title: LocaleKeys.pushNotificationsConsentPopupTitle.tr(),
      subtitle: LocaleKeys.pushNotificationsConsentPopupDesc.tr(),
      primaryButton: ButtonPrimary(
        onPressed: () => _completePushNotificationsFlow(
          context,
          userPreferencesStore: userPreferencesStore,
          userAllowed: true,
        ),
        child: Text(LocaleKeys.allowPushNotificationsBtn.tr()),
      ),
      secondaryButton: ButtonSecondary(
        onPressed: () => _completePushNotificationsFlow(
          context,
          userPreferencesStore: userPreferencesStore,
          userAllowed: false,
        ),
        child: Text(LocaleKeys.notNowBtn.tr()),
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
