import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> showPushNotificationsPermissionDialog(BuildContext context) async {
  await showModal(context, builder: (_) => const _DialogContent());
}

class _DialogContent extends HookConsumerWidget {
  const _DialogContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPreferencesStore = ref.watch(userPreferencesStorePOD);
    final screenType = ScreenType.of(context);
    final isDesktop = screenType >= ScreenType.tablet;
    return PromptDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: isDesktop ? 144 : 24),
      buttonsPadding: EdgeInsets.fromLTRB(isDesktop ? 144 : 16, 0, isDesktop ? 144 : 16, 50),
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
