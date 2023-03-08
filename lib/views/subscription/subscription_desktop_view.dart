import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/base_layout.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/subscription_app_bar.dart';
import 'package:styled_widget/styled_widget.dart';

class SubscriptionDesktopView extends ConsumerWidget {
  const SubscriptionDesktopView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStore = ref.watch(authStorePOD);

    return BaseLayout(
      header: SubscriptionAppBar(authStore: authStore),
      child: Center(
        child: EasyText(
          LocaleKeys.subscriptionDesktop.tr(),
          maxLines: 4,
          color: Palette.purple,
          textAlign: TextAlign.center,
        ).paddingDirectional(all: 20),
      ),
    );
  }
}
