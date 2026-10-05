import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/ui/keys.dart';
import 'package:mysterium_vpn/components/dialogs/async_prompt_dialog.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> showPushNotificationsPermissionDialog(BuildContext context) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final userPreferencesStore = container.read(userPreferencesStorePOD);
  final analyticsStore = container.read(analyticsStorePOD);
  final logger = container.read(loggerPOD);
  analyticsStore.logPushNotificationsPromptShown().ignore();

  Future<void> complete({required bool userAllowed}) async {
    analyticsStore.logPushNotificationsPromptDecision(accepted: userAllowed).ignore();
    try {
      await userPreferencesStore.setPushNotificationsShown(userAllowed: userAllowed);
    } catch (e, stack) {
      // Cooldown is already stamped, so nothing to tell the user — but the
      // prompt re-evaluation inside can fail too, and that should be visible.
      logger.warning('Push notifications prompt decision failed', e, stack);
    }
  }

  await showModal<void>(
    context,
    builder: (ctx) => AsyncPromptDialog(
      key: K.pushNotificationsDialog,
      image: Asset.images.pnConsent(ctx).image(),
      title: S.current.pushNotificationsConsentPopupTitle,
      subtitle: S.current.pushNotificationsConsentPopupDesc,
      // On the impression, so the cooldown starts even if the app dies while
      // the OS permission sheet is up.
      onShown: userPreferencesStore.markPushPromptShown,
      primaryLabel: S.current.allowPushNotificationsBtn,
      onPrimary: () => complete(userAllowed: true),
      secondaryKey: K.pushNotificationsDeclineButton,
      secondaryLabel: S.current.notNowBtn,
      onSecondary: () => complete(userAllowed: false),
    ),
  );
}
