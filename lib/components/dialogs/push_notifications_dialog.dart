import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> showPushNotificationsPermissionDialog(BuildContext context) async {
  await showModal(context, builder: (_) => const _DialogContent(key: K.pushNotificationsDialog));
}

class _DialogContent extends HookConsumerWidget {
  const _DialogContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPreferencesStore = ref.watch(userPreferencesStorePOD);
    return PromptDialog(
      image: Asset.images.pnConsent(context).image(),
      title: S.current.pushNotificationsConsentPopupTitle,
      subtitle: S.current.pushNotificationsConsentPopupDesc,
      primaryButton: ButtonPrimary(
        onPressed: () => _completePushNotificationsFlow(
          context,
          userPreferencesStore: userPreferencesStore,
          userAllowed: true,
        ),
        child: Text(S.current.allowPushNotificationsBtn, textAlign: TextAlign.center),
      ),
      secondaryButton: ButtonSecondary(
        key: K.pushNotificationsDeclineButton,
        onPressed: () => _completePushNotificationsFlow(
          context,
          userPreferencesStore: userPreferencesStore,
          userAllowed: false,
        ),
        child: Text(S.current.notNowBtn, textAlign: TextAlign.center),
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
