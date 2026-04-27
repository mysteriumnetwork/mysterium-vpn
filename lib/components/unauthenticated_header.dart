import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class UnauthenticatedHeader extends StatelessWidget {
  const UnauthenticatedHeader({this.backHeader = false, super.key});

  final bool backHeader;

  @override
  Widget build(BuildContext context) {
    final authSessionStore = getIt<AuthSessionStore>();
    final analyticsStore = getIt<AnalyticsStore>();

    return Observer(
      builder: (_) {
        final canBrowseApp = authSessionStore.canBrowseApp;

        Future<void> handleBackOrHome() async {
          final beamer = Beamer.of(context);
          final success = await beamer.popRoute();
          if (!success) {
            beamer.beamToNamed(Routes.main.path);
          }
        }

        final theme = Theme.of(context);

        return backHeader
            ? Header(backgroundColor: theme.palette.bgSidePanel, backLabel: LocaleKeys.back.tr())
            : Header.logo(
                onBackPressed: handleBackOrHome,
                backgroundColor: theme.palette.bgSidePanel,
                centerTitle: true,
                showBackButton: canBrowseApp,
                actions: [
                  IconButton(
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(32, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(UntitledUI.message_question_square, size: 24),
                    onPressed: () =>
                        handleOnSupportPage(context: context, analyticsStore: analyticsStore),
                  ),
                ],
              );
      },
    );
  }
}
