import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/ui/keys.dart';
import 'package:mysterium_vpn/components/dialogs/async_prompt_dialog.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> showPushNotificationsPermissionDialog(BuildContext context) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final userPreferencesStore = container.read(userPreferencesStorePOD);
  final analyticsStore = container.read(analyticsStorePOD);
  analyticsStore.logPushNotificationsPromptShown().ignore();
  // Up front, so the cooldown starts even if the app dies while the OS
  // permission sheet is up.
  await userPreferencesStore.markPushPromptShown();
  if (!context.mounted) {
    return;
  }

  Future<void> complete({required bool userAllowed}) async {
    analyticsStore.logPushNotificationsPromptDecision(accepted: userAllowed).ignore();
    try {
      await userPreferencesStore.setPushNotificationsShown(userAllowed: userAllowed);
    } catch (_) {
      // The cooldown is already stamped; nothing actionable to tell the user.
    }
  }

  await showModal<void>(
    context,
    builder: (ctx) => AsyncPromptDialog(
      key: K.pushNotificationsDialog,
      image: Asset.images.pnConsent(ctx).image(),
      title: S.current.pushNotificationsConsentPopupTitle,
      subtitle: S.current.pushNotificationsConsentPopupDesc,
      primaryLabel: S.current.allowPushNotificationsBtn,
      onPrimary: () => complete(userAllowed: true),
      secondaryKey: K.pushNotificationsDeclineButton,
      secondaryLabel: S.current.notNowBtn,
      onSecondary: () => complete(userAllowed: false),
    ),
  );
}
