import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class CheckYourEmailView extends HookConsumerWidget {
  const CheckYourEmailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStore = ref.watch(authStorePOD);

    return Scaffold(
      body: SafeArea(
        child: Observer(
          builder: (context) => Stack(
            children: [
              Column(
                children: [
                  EasyText(
                    LocaleKeys.checkYourEmail.tr(),
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ).padding(bottom: 60, top: 20),
                  const SvgIcon(
                    asset: Assets.checkEmail,
                  ).padding(bottom: 40),
                  EasyText(
                    LocaleKeys.emailSentTo.tr(namedArgs: {'email': authStore.email}),
                    maxLines: 2,
                    color: Palette.lightBlack,
                  ).padding(bottom: 30),
                  EasyText(
                    LocaleKeys.linkExpires.tr(),
                    maxLines: 2,
                  ).padding(bottom: 10),
                  EasyText(
                    LocaleKeys.goCheckYourEmail.tr(),
                  ),
                ],
              ).scrollable(),
              if (authStore.authStatus == AuthStatus.authenticating)
                LoadingBarrier(color: Theme.of(context).primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}
