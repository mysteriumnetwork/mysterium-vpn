import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/ui/keys.dart';
import 'package:mysterium_vpn/common/ui/ui.dart';
import 'package:mysterium_vpn/components/dialogs/async_prompt_dialog.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> showMarketingConsentDialog(BuildContext context) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final userPreferencesStore = container.read(userPreferencesStorePOD);
  container.read(analyticsStorePOD).logMarketingConsentPromptShown().ignore();

  Future<void> submit({required bool consent}) async {
    try {
      await userPreferencesStore.updateMarketingContact(consent: consent, fromPopup: true);
    } catch (_) {
      showSnackbar(S.current.somethingWentWrong);
    }
  }

  await showModal<void>(
    context,
    builder: (ctx) => AsyncPromptDialog(
      key: Keys.marketingConsentDialog,
      image: Asset.images.emailConsent(ctx).image(),
      title: S.current.marketingConsentPopupTitle,
      subtitle: S.current.marketingConsentPopupDesc,
      // On the impression, not on the answer: a dismissal or a failed request
      // must not leave it unset and re-prompt every launch. Settings still
      // toggles the consent.
      onShown: userPreferencesStore.setMarketingConsentShown,
      primaryKey: Keys.marketingConsentAcceptButton,
      primaryLabel: S.current.allowNotificationsBtn,
      onPrimary: () => submit(consent: true),
      secondaryKey: Keys.marketingConsentDeclineButton,
      secondaryLabel: S.current.notNowBtn,
      onSecondary: () => submit(consent: false),
    ),
  );
}
