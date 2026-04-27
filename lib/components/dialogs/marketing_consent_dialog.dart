import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/settings/store/user_preferences_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> showMarketingConsentDialog(BuildContext context) async {
  await showModal<void>(
    context,
    builder: (_) => const _DialogContent(),
    desktopConstraints: const BoxConstraints(maxWidth: 600, maxHeight: 400),
  );
}

class _DialogContent extends StatefulWidget {
  const _DialogContent();

  @override
  State<_DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<_DialogContent> {
  final _userPreferencesStore = getIt<UserPreferencesStore>();
  bool? _lastClickedConsent;

  @override
  Widget build(BuildContext context) {
    final screenType = ScreenType.of(context);
    return Observer(
      builder: (context) {
        final isLoading =
            _userPreferencesStore.updateMarketingConsentFuture.status == FutureStatus.pending;
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
          primaryButton: ButtonPrimary(
            key: Keys.marketingConsentAcceptButton,
            onPressed: () {
              setState(() => _lastClickedConsent = true);
              _updateMarketingConsent(context, consent: true);
            },
            loading: isLoading && (_lastClickedConsent ?? false) ? const ButtonLoading() : null,
            child: Text(LocaleKeys.allowNotificationsBtn.tr()),
          ),
          secondaryButton: ButtonSecondary(
            key: Keys.marketingConsentDeclineButton,
            onPressed: () {
              setState(() => _lastClickedConsent = false);
              _updateMarketingConsent(context, consent: false);
            },
            loading: isLoading && _lastClickedConsent == false ? const ButtonLoading() : null,
            child: Text(LocaleKeys.notNowBtn.tr()),
          ),
        );
      },
    );
  }
}

Future<void> _updateMarketingConsent(BuildContext context, {required bool consent}) async {
  await getIt<UserPreferencesStore>().updateMarketingContact(consent: consent, fromPopup: true);

  if (context.mounted) {
    Navigator.of(context).pop();
  }
}
