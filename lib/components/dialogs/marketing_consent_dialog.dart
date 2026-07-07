import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/utils/keys.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> showMarketingConsentDialog(BuildContext context) async {
  await showModal<void>(context, builder: (_) => const _DialogContent());
}

class _DialogContent extends HookConsumerWidget {
  const _DialogContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPreferencesStore = ref.watch(userPreferencesStorePOD);
    final lastClickedConsent = useState<bool?>(null);
    return Observer(
      builder: (context) {
        final isLoading =
            userPreferencesStore.updateMarketingConsentFuture.status == FutureStatus.pending;
        return PromptDialog(
          image: Asset.images.emailConsent(context).image(),
          title: S.current.marketingConsentPopupTitle,
          subtitle: S.current.marketingConsentPopupDesc,
          primaryButton: ButtonPrimary(
            key: Keys.marketingConsentAcceptButton,
            onPressed: () {
              lastClickedConsent.value = true;
              _updateMarketingConsent(context, consent: true);
            },
            loading: isLoading && (lastClickedConsent.value ?? false)
                ? const ButtonLoading()
                : null,
            child: Text(S.current.allowNotificationsBtn),
          ),
          secondaryButton: ButtonSecondary(
            key: Keys.marketingConsentDeclineButton,
            onPressed: () {
              lastClickedConsent.value = false;
              _updateMarketingConsent(context, consent: false);
            },
            loading: isLoading && lastClickedConsent.value == false ? const ButtonLoading() : null,
            child: Text(S.current.notNowBtn),
          ),
        );
      },
    );
  }
}

Future<void> _updateMarketingConsent(BuildContext context, {required bool consent}) async {
  await ProviderScope.containerOf(
    context,
    listen: false,
  ).read(userPreferencesStorePOD).updateMarketingContact(consent: consent, fromPopup: true);

  if (context.mounted) {
    Navigator.of(context).pop();
  }
}
