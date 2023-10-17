import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/enum.dart';
import 'package:mysterium_vpn/common/forms/forms.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/border_button.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:styled_widget/styled_widget.dart';

class SignInForm extends HookConsumerWidget {
  const SignInForm({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInForm = useMemoized(singIn);
    final isMounted = useIsMounted();
    final store = ref.watch(authStorePOD);
    final form = useMemoized(approval);

    return ReactiveForm(
      formGroup: signInForm,
      child: Column(
        children: [
          AutofillGroup(
            child: ReactiveTextField(
              decoration: InputDecoration(labelText: LocaleKeys.email.tr()),
              formControlName: 'email',
              autofillHints: const [AutofillHints.email],
              keyboardType: TextInputType.emailAddress,
              onSubmitted: (control) => _onSignInPressed(signInForm, isMounted, context, store),
              onEditingComplete: (_) => TextInput.finishAutofillContext(),
              validationMessages: {
                ValidationMessage.required: (_) => LocaleKeys.emailIsRequired.tr(),
                ValidationMessage.email: (_) => LocaleKeys.emailIsNotValid.tr(),
              },
            ).padding(bottom: 10),
          ),
          ReactiveForm(
            formGroup: form,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReactiveCheckbox(
                  formControlName: 'approval',
                ),
                EasyText(
                  LocaleKeys.emaillCommunicationsApproval.tr(),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ).expanded(),
              ],
            ).padding(bottom: 10),
          ),
          Observer(
            builder: (_) {
              final status = store.loginFeature.status;
              return ReactiveFormConsumer(
                builder: (_, signInForm, child) => EasyButton(
                  width: double.infinity,
                  onPressed: status != FutureStatus.pending
                      ? () => _onSignInPressed(signInForm, isMounted, context, store)
                      : null,
                  child: status != FutureStatus.pending
                      ? EasyText(
                          LocaleKeys.continueWithEmail.tr(),
                          color: Palette.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        )
                      : const LoadingIndicator(
                          radius: 20,
                          strokeWidth: 1.5,
                        ),
                ),
              );
            },
          ),
          Visibility(
            visible: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Divider(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ).width(100),
                    EasyText(
                      LocaleKeys.or.tr(),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ).padding(horizontal: 10),
                    Divider(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ).width(100),
                  ],
                ).padding(vertical: 25),
                BorderButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SvgIcon(asset: Assets.googleLogo).padding(right: 10),
                      EasyText(
                        LocaleKeys.continueWithGoogle.tr(),
                        color: Palette.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ).padding(bottom: 20),
                BorderButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SvgIcon(asset: Assets.appleLogo).paddingDirectional(end: 10),
                      EasyText(
                        LocaleKeys.continueWithApple.tr(),
                        color: Palette.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSignInPressed(
    FormGroup form,
    bool Function() isMounted,
    BuildContext context,
    AuthStore store,
  ) async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    TextInput.finishAutofillContext();
    final email = form.control('email').value as String;
    final result = await store.login(email: email);
    if (isMounted() && result == null) {
      // ignore: use_build_context_synchronously
      context.beamToNamed(Routes.checkYourEmail.toRoute);
    }
  }
}
