import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/service_locator.dart';

class UnauthenticatedHeader extends StatelessWidget {
  const UnauthenticatedHeader({
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
    super.key,
  });

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final authSessionStore = getIt<AuthSessionStore>();
    final analyticsStore = getIt<AnalyticsStore>();

    return Observer(
      builder: (_) {
        final canBrowseApp = authSessionStore.canBrowseApp;
        return Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 24,
            children: [
              if (canBrowseApp) const _BackButton(),
              if (!canBrowseApp) const SizedBox.shrink(),
              const Expanded(child: AppLogo()),
              SvgIconButton(
                asset: Asset.icons.supportLight,
                onPressed: () {
                  handleOnSupportPage(context: context, analyticsStore: analyticsStore);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    Future<void> handleBackOrHome() async {
      final beamer = Beamer.of(context);
      final success = await beamer.popRoute();
      if (!success) {
        beamer.beamToNamed(Routes.main.path);
      }
    }

    return SvgIconButton(
      key: K.backButton,
      asset: Asset.icons.navigateBackLighter(context),
      onPressed: handleBackOrHome,
    );
  }
}
