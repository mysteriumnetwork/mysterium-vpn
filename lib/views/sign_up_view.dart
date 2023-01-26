import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/sign_up_form.dart';
import 'package:styled_widget/styled_widget.dart';

class SignUpView extends HookConsumerWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loco = ref.watch(localeStorePOD).loco;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                EasyText(
                  loco.sign_up,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ).padding(bottom: 30),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    EasyText(
                      loco.already_have_account,
                      color: Palette.lightBlack,
                    ),
                    InkWell(
                      child: EasyText(
                        loco.sign_in,
                        color: Palette.pink,
                      ),
                      onTap: () {},
                    ),
                  ],
                ).padding(bottom: 30),
                SignUpForm(
                  loco: loco,
                ),
              ],
            ),
          ),
        ),
      ),
    ).height(MediaQuery.of(context).size.height * .8);
  }
}
