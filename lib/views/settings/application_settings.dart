import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/auth_status.dart';
import 'package:mysterium_vpn/common/enums/screen_type.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/hooks/screen_type_hook.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/setting_item.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/email_marketing_setting.dart';
import 'package:mysterium_vpn/views/settings/language_picker.dart';
import 'package:mysterium_vpn/views/settings/push_notifications_settings.dart';
import 'package:mysterium_vpn/views/settings/theme_picker.dart';
import 'package:styled_widget/styled_widget.dart';

class ApplicationSettings extends HookConsumerWidget {
  const ApplicationSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    final localeStore = ref.read(localeStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);
    final authSessionStore = ref.watch(authSessionStorePOD);
    final userPreferencesStore = ref.watch(userPreferencesStorePOD);
    final pushNotificationsStore = ref.watch(pushNotificationsStorePOD);

    final screenType = useScreenType();
    final isMobile = screenType == ScreenType.mobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingItem(
          asset: Asset.icons.language(context),
          title: LocaleKeys.appLang.tr(),
          actionWidget: LanguagePicker(
            store: localeStore,
            analyticsStore: analyticsStore,
          ),
        ),
        SettingItem(
          asset: Asset.icons.theme(context),
          title: LocaleKeys.theme.tr(),
          actionWidget: ThemePicker(
            store: themeStore,
            analyticsStore: analyticsStore,
          ),
        ),
        Builder(
          builder: (context) {
            final notificationsTitleVisible = (userPreferencesStore.marketingConsent != null ||
                    pushNotificationsStore.supportsPushNotifications) &&
                authSessionStore.status == AuthStatus.authenticated;
            return Visibility(
              visible: notificationsTitleVisible,
              child: EasyText(
                LocaleKeys.notificationsSettingTitle.tr(),
                fontSize: isMobile ? 16 : 14,
                fontWeight: isMobile ? FontWeight.w600 : FontWeight.w400,
              ).padding(
                bottom: 16,
                left: 20,
                top: isMobile ? 16 : 30,
                right: 0,
              ),
            );
          },
        ),
        const EmailMarketingSetting(),
        const PushNotificationsSetting(),
      ],
    );
  }
}
