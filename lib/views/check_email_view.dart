import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class CheckYourEmailView extends HookConsumerWidget {
  const CheckYourEmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loco = ref.watch(localeStorePOD).loco;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EasyText(
              loco.check_your_email,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ).padding(bottom: 60, top: 20),
            const SvgIcon(
              asset: Assets.checkEmail,
            ).padding(bottom: 40),
            EasyText(
              loco.email_sent_to("kmitrikjeski@gmail.com"),
              maxLines: 2,
              color: Palette.lightBlack,
            ).padding(bottom: 30),
            EasyText(
              loco.link_expires,
              maxLines: 2,
            ).padding(bottom: 10),
            EasyText(
              loco.go_check_your_email,
            ),
          ],
        ),
      ),
    );
  }
}
