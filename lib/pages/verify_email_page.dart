import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/unauthenticated_page_view.dart';
import 'package:mysterium_vpn/views/verify_email_view.dart';
import 'package:styled_widget/styled_widget.dart';

class VerifyEmailPage extends ConsumerWidget {
  const VerifyEmailPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.read(analyticsStorePOD);
    final size = Size(getMediaWidth(context), getMediaHeight(context));

    return UnauthenticatedPageView(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  SvgIconButton(
                    onPressed: () {
                      analyticsStore.logEvent(AnalyticsEvent.backButtonClick);
                      context.beamBack();
                    },
                    asset: context.c.isDarkMode
                        ? Assets.navigateBackLightGrey
                        : Assets.navigateBackLightBlack,
                  ).padding(left: 20),
                  const AppLogo().expanded(),
                  const SizedBox(width: 70),
                ],
              ).padding(
                top: size.height * 0.02,
                bottom: size.height * 0.03,
              ),
              const VerifyEmailView()
                  .decorated(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  )
                  .expanded(),
            ],
          ),
        ),
      ),
    );
  }
}
