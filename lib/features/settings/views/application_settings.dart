import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/enums/auth_status.dart';
import 'package:mysterium_vpn/core/enums/screen_type.dart';
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/core/locale/locale_store.dart';
import 'package:mysterium_vpn/core/theme/theme_store.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/notifications/store/push_notifications_store.dart';
import 'package:mysterium_vpn/features/settings/store/user_preferences_store.dart';
import 'package:mysterium_vpn/features/settings/views/email_marketing_setting.dart';
import 'package:mysterium_vpn/features/settings/views/language_picker.dart';
import 'package:mysterium_vpn/features/settings/views/push_notifications_settings.dart';
import 'package:mysterium_vpn/features/settings/views/theme_picker.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/shared/components/easy_text.dart';
import 'package:mysterium_vpn/shared/components/setting_item.dart';
import 'package:styled_widget/styled_widget.dart';

class ApplicationSettings extends StatelessWidget {
  const ApplicationSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeStore = getIt<ThemeStore>();
    final localeStore = getIt<LocaleStore>();
    final analyticsStore = getIt<AnalyticsStore>();
    final authSessionStore = getIt<AuthSessionStore>();
    final userPreferencesStore = getIt<UserPreferencesStore>();
    final pushNotificationsStore = getIt<PushNotificationsStore>();
    final screenType = getScreenType(MediaQuery.of(context).size);
    final isMobile = screenType == ScreenType.mobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingItem(
          asset: Asset.icons.language(context),
          title: LocaleKeys.appLang.tr(),
          actionWidget: LanguagePicker(store: localeStore, analyticsStore: analyticsStore),
        ),
        SettingItem(
          asset: Asset.icons.theme(context),
          title: LocaleKeys.theme.tr(),
          actionWidget: ThemePicker(store: themeStore, analyticsStore: analyticsStore),
        ),
        Observer(
          builder: (context) {
            final notificationsTitleVisible =
                (userPreferencesStore.marketingConsent != null ||
                    pushNotificationsStore.supportsPushNotifications) &&
                authSessionStore.status == AuthStatus.authenticated;
            return Visibility(
              visible: notificationsTitleVisible,
              child: EasyText(
                LocaleKeys.notificationsSettingTitle.tr(),
                fontSize: isMobile ? 16 : 14,
                fontWeight: isMobile ? FontWeight.w600 : FontWeight.w400,
              ).padding(bottom: 16, left: 20, top: isMobile ? 16 : 30, right: 0),
            );
          },
        ),
        const PushNotificationsSetting(),
        const EmailMarketingSetting(),
      ],
    );
  }
}
