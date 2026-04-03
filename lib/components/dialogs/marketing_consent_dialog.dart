import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/common/utils/keys.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide ScreenType;

Future<void> showMarketingConsentDialog(BuildContext context) async {
  await showModal<void>(
    context,
    builder: (_) => const _DialogContent(),
    desktopConstraints: const BoxConstraints(maxWidth: 600, maxHeight: 400),
  );
}

class _DialogContent extends HookConsumerWidget {
  const _DialogContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPreferencesStore = ref.watch(userPreferencesStorePOD);
    final screenType = useScreenType();
    final palette = Theme.of(context).palette;
    return Observer(
      builder: (context) {
        final isLoading =
            userPreferencesStore.updateMarketingConsentFuture.status == FutureStatus.pending;
        return PromptDialog(
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenType == ScreenType.mobile ? 24 : 144,
          ),
          buttonsPadding: EdgeInsets.fromLTRB(
            screenType == ScreenType.mobile ? 16 : 144,
            0,
            screenType == ScreenType.mobile ? 16 : 144,
            50,
          ),
          image: Asset.images.emailConsent(context).image(),
          title: LocaleKeys.marketingConsentPopupTitle.tr(),
          subtitle: LocaleKeys.marketingConsentPopupDesc.tr(),
          primaryButton: isLoading
              ? const Center(child: LoadingIndicator())
              : ButtonPrimary(
                  key: Keys.marketingConsentAcceptButton,
                  onPressed: () => _updateMarketingConsent(context, consent: true),
                  child: Text(LocaleKeys.allowNotificationsBtn.tr()),
                ),
          secondaryButton: isLoading
              ? null
              : ButtonSecondary(
                  key: Keys.marketingConsentDeclineButton,
                  onPressed: () => _updateMarketingConsent(context, consent: false),
                  decoration: ButtonDecoration(
                    borderColor: palette.borderBrandSecondary,
                    foregroundColor: palette.textSecondary,
                    decorationColor: Palette.white,
                  ),
                  child: Text(LocaleKeys.notNowBtn.tr()),
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
