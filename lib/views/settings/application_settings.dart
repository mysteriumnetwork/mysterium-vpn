import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/email_marketing_setting.dart';
import 'package:mysterium_vpn/views/settings/language_picker.dart';
import 'package:mysterium_vpn/views/settings/push_notifications_settings.dart';
import 'package:mysterium_vpn/views/settings/theme_picker.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide ScreenType;
import 'package:styled_widget/styled_widget.dart';

class ApplicationSettings extends ConsumerWidget {
  const ApplicationSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSessionStore = ref.watch(authSessionStorePOD);
    final userPreferencesStore = ref.watch(userPreferencesStorePOD);
    final pushNotificationsStore = ref.watch(pushNotificationsStorePOD);

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
                if (isDesktop) SizedBox(height: theme.spacing.md),
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
