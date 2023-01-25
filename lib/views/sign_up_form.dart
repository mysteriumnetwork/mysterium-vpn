import 'package:beamer/beamer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/forms/forms.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/border_button.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:styled_widget/styled_widget.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key, required this.loco});
  final AppLocalizations loco;
  @override
  Widget build(BuildContext context) {
    final signUpForm = useMemoized(() => AppForms.singUp());

    return ReactiveForm(
      formGroup: signUpForm,
      child: Column(
        children: [
          ReactiveTextField(
            decoration: InputDecoration(labelText: loco.email),
            formControlName: 'email',
            validationMessages: {
              ValidationMessage.required: (_) => loco.email_is_required,
              ValidationMessage.email: (_) => loco.email_is_not_valid,
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
                child: EasyText(loco.continue_with_email, color: Palette.white),
              ).width(double.infinity);
            },
          ).padding(bottom: 50),
          BorderButton(
            color: Palette.lightBlue,
            onPressed: () {},
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SvgIcon(asset: Assets.googleLogo).padding(right: 10),
              EasyText(
                loco.continue_with_google,
              ),
            ]),
          ).width(double.infinity).padding(bottom: 20),
          BorderButton(
            onPressed: () {},
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SvgIcon(asset: Assets.appleLogo).padding(right: 10),
              EasyText(
                loco.continue_with_apple,
              ),
            ]),
          ).width(double.infinity).padding(bottom: 20),
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
                    TextSpan(text: "${loco.accept} "),
                    TextSpan(
                        text: loco.terms_and_conditions,
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
