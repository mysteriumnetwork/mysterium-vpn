import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/settings/store/user_preferences_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

class EmailMarketingSetting extends StatelessWidget {
  const EmailMarketingSetting({required this.position, super.key});

  final SettingsCardPosition position;

  @override
  Widget build(BuildContext context) {
    final authSessionStore = getIt<AuthSessionStore>();
    final userPreferencesStore = getIt<UserPreferencesStore>();
    final analyticsStore = getIt<AnalyticsStore>();

    return Observer(
      builder: (_) {
        final visible =
            userPreferencesStore.marketingConsent != null &&
            authSessionStore.status == AuthStatus.authenticated;

        if (!visible) {
          return const SizedBox.shrink();
        }

        final isLoading =
            userPreferencesStore.updateMarketingConsentFuture.status == FutureStatus.pending ||
            userPreferencesStore.getMarketingConsentFuture?.status == FutureStatus.pending;

        return SettingsCard(
          title: LocaleKeys.emailNotificationsSetting.tr(),
          position: position,
          trailing: isLoading
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
        );
      },
    );
  }
}
