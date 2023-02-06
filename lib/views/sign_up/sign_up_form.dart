import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/forms/forms.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/border_button.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:styled_widget/styled_widget.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});
  @override
  Widget build(BuildContext context) {
    final signUpForm = useMemoized(() => AppForms.singUp());

    return ReactiveForm(
      formGroup: signUpForm,
      child: Column(
        children: [
          ReactiveTextField(
            decoration: InputDecoration(labelText: LocaleKeys.email.tr()),
            formControlName: 'email',
            validationMessages: {
              ValidationMessage.required: (_) => LocaleKeys.emailIsRequired.tr(),
              ValidationMessage.email: (_) => LocaleKeys.emailIsNotValid.tr(),
            },
          ).padding(bottom: 20),
          ReactiveFormConsumer(
            builder: (context, form, child) {
              return EasyButton(
                useSystemColor: false,
                onPressed: form.valid
                    ? () {
                        context.beamToNamed('/check-your-email');
                      }
                    : () => form.markAllAsTouched(),
                child: EasyText(LocaleKeys.continueWithEmail.tr(), color: Palette.white),
              );
            },
          ).padding(bottom: 50),
          BorderButton(
            color: Palette.lightBlue,
            onPressed: () {},
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SvgIcon(asset: Assets.googleLogo).padding(right: 10),
              EasyText(
                LocaleKeys.continueWithGoogle.tr(),
              ),
            ]),
          ),
          BorderButton(
            onPressed: () {},
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SvgIcon(asset: Assets.appleLogo).padding(right: 10),
              EasyText(
                LocaleKeys.continueWithApple.tr(),
              ),
            ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ReactiveCheckbox(
                formControlName: 'terms_acceptance',
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Palette.lightBlack),
                  children: [
                    TextSpan(text: "${LocaleKeys.accept.tr()} "),
                    TextSpan(
                        text: LocaleKeys.termsAndConditions.tr(),
                        style: const TextStyle(
                          color: Palette.lightBlack,
                          decoration: TextDecoration.underline,
                        ),
                        mouseCursor: MaterialStateMouseCursor.clickable,
                        recognizer: TapGestureRecognizer()..onTap = () {}),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
