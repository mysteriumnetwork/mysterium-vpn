import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/enum.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/views/sign_in/sign_in_form.dart';
import 'package:styled_widget/styled_widget.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  EasyText(
                    LocaleKeys.signIn.tr(),
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ).padding(bottom: 20),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      EasyText(
                        LocaleKeys.dontHaveAccount.tr(),
                        color: Palette.lightBlack,
                      ),
                      InkWell(
                        child: EasyText(
                          LocaleKeys.signUp.tr(),
                          color: Palette.pink,
                        ),
                        onTap: () {
                          context.beamToReplacementNamed(Routes.signUp.toRoute);
                        },
                      ),
                    ],
                  ).padding(bottom: 50),
                  const SignInForm(),
                ],
              ),
            ),
          ),
        ),
      );
}
