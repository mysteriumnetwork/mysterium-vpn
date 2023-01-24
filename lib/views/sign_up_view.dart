import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mysterium_vpn/common/forms/forms.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/border_button.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:styled_widget/styled_widget.dart';

void showSignInView(BuildContext context) {
  showBarModalBottomSheet(
    expand: false,
    context: context,
    backgroundColor: Palette.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) => const SignUpView(),
  );
}

class SignUpView extends HookConsumerWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loco = ref.watch(localeStorePOD).loco;
    final signUpForm = useMemoized(() => AppForms.singUp());

    return SizedBox(
      height: MediaQuery.of(context).size.height * .8,
      child: Material(
        child: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (context2) => Builder(
              builder: (ctx) => Scaffold(
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
                          ReactiveForm(
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
                                    return SizedBox(
                                      width: double.infinity,
                                      child: EasyButton(
                                        useSystemColor: false,
                                        onPressed: form.valid ? () {} : () => form.markAllAsTouched(),
                                        child: EasyText(loco.continue_with_email, color: Palette.white),
                                      ),
                                    );
                                  },
                                ).padding(bottom: 50),
                                SizedBox(
                                  width: double.infinity,
                                  child: BorderButton(
                                    color: Palette.lightBlue,
                                    onPressed: () {},
                                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      const SvgIcon(asset: Assets.googleLogo).padding(right: 10),
                                      EasyText(
                                        loco.continue_with_google,
                                      ),
                                    ]),
                                  ),
                                ).padding(bottom: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: BorderButton(
                                    onPressed: () {},
                                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      const SvgIcon(asset: Assets.appleLogo).padding(right: 10),
                                      EasyText(
                                        loco.continue_with_apple,
                                      ),
                                    ]),
                                  ),
                                ).padding(bottom: 20),
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
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
