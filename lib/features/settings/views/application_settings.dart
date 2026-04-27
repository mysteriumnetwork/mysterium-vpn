import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/enums/auth_status.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/notifications/store/push_notifications_store.dart';
import 'package:mysterium_vpn/features/settings/store/user_preferences_store.dart';
import 'package:mysterium_vpn/features/settings/views/email_marketing_setting.dart';
import 'package:mysterium_vpn/features/settings/views/language_picker.dart';
import 'package:mysterium_vpn/features/settings/views/push_notifications_settings.dart';
import 'package:mysterium_vpn/features/settings/views/theme_picker.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

class ApplicationSettings extends StatelessWidget {
  const ApplicationSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final authSessionStore = getIt<AuthSessionStore>();
    final userPreferencesStore = getIt<UserPreferencesStore>();
    final pushNotificationsStore = getIt<PushNotificationsStore>();

    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
    final theme = Theme.of(context);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LanguagePicker(position: SettingsCardPosition.top),
        const ThemePicker(position: SettingsCardPosition.bottom),
        Observer(
          builder: (_) {
            final isAuthenticated = authSessionStore.status == AuthStatus.authenticated;
            final showPush = pushNotificationsStore.supportsPushNotifications && isAuthenticated;
            final showEmail = userPreferencesStore.marketingConsent != null && isAuthenticated;
            final showCommunications = showPush || showEmail;

            if (!showCommunications) {
              return const SizedBox.shrink();
            }

            final pushPosition = showEmail ? SettingsCardPosition.top : SettingsCardPosition.single;
            final emailPosition = showPush
                ? SettingsCardPosition.bottom
                : SettingsCardPosition.single;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: theme.spacing.xl2),
                if (isDesktop)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: theme.spacing.md,
                      vertical: theme.spacing.s,
                    ),
                    decoration: BoxDecoration(
                      color: theme.palette.bgSidePanel,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      LocaleKeys.communicationLblDesktop.tr(),
                      style: theme.textStyles.textXs.semibold.copyWith(
                        color: theme.palette.textSecondary,
                      ),
                    ),
                  )
                else
                  Text(
                    LocaleKeys.communicationLbl.tr(),
                    style: theme.textStyles.textMd.regular.copyWith(
                      color: theme.palette.textTertiary,
                    ),
                  ).padding(bottom: theme.spacing.sm),
                if (showPush) PushNotificationsSetting(position: pushPosition),
                if (showEmail) EmailMarketingSetting(position: emailPosition),
              ],
            );
          },
        ),
      ],
    );

    return isDesktop
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.xl3),
            child: content,
          )
        : content;
  }
}
