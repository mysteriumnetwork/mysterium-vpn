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
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/social_login_button.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:styled_widget/styled_widget.dart';

class SignInForm extends HookConsumerWidget {
  const SignInForm({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);
    final store = ref.watch(authStorePOD);
    final signInForm = useMemoized(() {
      final form = singIn();
      form.control('email').value = store.email;
      return form;
    });
    final marketingConsentForm = useMemoized(marketingConsent);

    return Observer(
      builder: (context) {
        final signInStatus = store.signInFeatureFeature.status;

        return Stack(
          children: [
            ReactiveForm(
              formGroup: signInForm,
              child: Column(
                children: [
                  AutofillGroup(
                    child: ReactiveTextField(
                      onTap: (_) {
                        analyticsStore.logEvent(AnalyticsEvent.emailInput);
                      },
                      decoration: InputDecoration(labelText: LocaleKeys.email.tr()),
                      formControlName: 'email',
                      autofillHints: const [AutofillHints.email],
                      keyboardType: TextInputType.emailAddress,
                      onSubmitted: (control) =>
                          _onSignInWithEmailPressed(signInForm, context, store, analyticsStore),
                      onEditingComplete: (_) => TextInput.finishAutofillContext(),
                      validationMessages: {
                        ValidationMessage.required: (_) => LocaleKeys.emailIsRequired.tr(),
                        ValidationMessage.email: (_) => LocaleKeys.emailIsNotValid.tr(),
                      },
                    ).padding(bottom: 10),
                  ),
                  ReactiveForm(
                    formGroup: marketingConsentForm,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ReactiveCheckbox(
                          formControlName: 'consent',
                          onChanged: (control) {
                            if (control.value != null) {
                              analyticsStore.logEvent(
                                AnalyticsEvent.marketingConsentClicked,
                                parameters: {
                                  'consent': control.value,
                                },
                              );
                              store.marketingConsent = control.value!;
                            }
                          },
                        ),
                        EasyText(
                          LocaleKeys.emaillCommunicationsApproval.tr(),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ).expanded(),
                      ],
                    ).padding(bottom: 10),
                  ),
                  ReactiveFormConsumer(
                    builder: (_, signInForm, child) => EasyButton(
                      width: double.infinity,
                      onPressed: signInStatus != FutureStatus.pending
                          ? () =>
                              _onSignInWithEmailPressed(signInForm, context, store, analyticsStore)
                          : null,
                      child: signInStatus == FutureStatus.pending &&
                              store.authenticatingType == GrantType.email
                          ? const LoadingIndicator(
                              radius: 20,
                              strokeWidth: 1.5,
                            )
                          : EasyText(
                              LocaleKeys.continueWithEmail.tr(),
                              color: Palette.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Divider(
                              color: Palette.lightBlack,
                            ),
                          ),
                          EasyText(
                            LocaleKeys.or.tr(),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Palette.lightBlack,
                          ).padding(horizontal: 8),
                          const Expanded(
                            child: Divider(
                              color: Palette.lightBlack,
                            ),
                          ),
                        ],
                      ).padding(vertical: 25),
                      SocialLoginButton(
                        onPressed: signInStatus == FutureStatus.pending
                            ? null
                            : () {
                                analyticsStore.logEvent(AnalyticsEvent.appleLogin);
                                store.signInWithApple();
                              },
                        isLoading: signInStatus == FutureStatus.pending &&
                            store.authenticatingType == GrantType.apple,
                        asset: Assets.appleLogo,
                        label: LocaleKeys.continueWithApple.tr(),
                      ).padding(bottom: 20),
                      SocialLoginButton(
                        onPressed: signInStatus == FutureStatus.pending
                            ? null
                            : () {
                                analyticsStore.logEvent(AnalyticsEvent.googleLogin);
                                store.signInWithGoogle();
                              },
                        isLoading: signInStatus == FutureStatus.pending &&
                            store.authenticatingType == GrantType.google,
                        asset: Assets.googleLogo,
                        label: LocaleKeys.continueWithGoogle.tr(),
                      ).padding(bottom: 20),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onSignInWithEmailPressed(
    FormGroup form,
    BuildContext context,
    AuthStore store,
    AnalyticsStore analyticsStore,
  ) async {
    analyticsStore.logEvent(
      AnalyticsEvent.emailLogin,
      parameters: {
        'valid': form.valid,
      },
    );
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    TextInput.finishAutofillContext();
    final email = form.control('email').value as String;
    final result = await store.signInwithEmail(email: email);
    if (context.mounted && result == null) {
      context.beamToNamed(Routes.checkYourEmail.toRoute, beamBackOnPop: true);
    }
  }
}
