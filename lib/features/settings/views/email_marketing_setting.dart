import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/settings/store/user_preferences_store.dart';
import 'package:mysterium_vpn/features/settings/views/switch_item.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:styled_widget/styled_widget.dart';

class EmailMarketingSetting extends StatelessWidget {
  const EmailMarketingSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final authSessionStore = getIt<AuthSessionStore>();
    final userPreferencesStore = getIt<UserPreferencesStore>();
    final analyticsStore = getIt<AnalyticsStore>();
    return Observer(
      builder: (context) {
        final shouldShowLoadingIndicator = _shouldShowLoadingIndicator(userPreferencesStore);
        final visible =
            userPreferencesStore.marketingConsent != null &&
            authSessionStore.status == AuthStatus.authenticated;
        return Visibility(
          visible: visible,
          child: SwitchItem(
            asset: Asset.icons.emailNotification(context),
            title: LocaleKeys.emailNotificationsSetting.tr(),
            subtitle: LocaleKeys.emailNotificationsSettingDesc.tr(),
            actionWidget: Observer(
              builder: (context) => shouldShowLoadingIndicator
                  ? const LoadingIndicator().padding(all: 8)
                  : Switch(
                      value: userPreferencesStore.marketingConsent!,
                      onChanged: (val) async {
                        try {
                          await userPreferencesStore.updateMarketingContact(consent: val);
                          analyticsStore.logEvent(
                            AnalyticsEvent.toggleMarketingConsent,
                            parameters: {'value': val.toString()},
                          );
                        } catch (e) {
                          showSnackbar(LocaleKeys.somethingWentWrong.tr());
                        }
                      },
                    ),
            ),
          ),
        );
      },
    );
  }

  bool _shouldShowLoadingIndicator(UserPreferencesStore userPreferencesStore) =>
      userPreferencesStore.updateMarketingConsentFuture.status == FutureStatus.pending ||
      userPreferencesStore.getMarketingConsentFuture?.status == FutureStatus.pending;
}
