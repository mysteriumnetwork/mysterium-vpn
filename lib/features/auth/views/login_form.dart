import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/constants/constants.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/forms/forms.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:styled_widget/styled_widget.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _analyticsStore = getIt<AnalyticsStore>();
  final _store = getIt<AuthStore>();
  late final FormGroup _signInForm = singIn();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final email = await _store.getLastLoggedInUser();
      if (!_signInForm.control('email').dirty) {
        _signInForm.control('email').value = email;
      }
    });
  }

  @override
  void dispose() {
    _signInForm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = getMediaHeight(context);

    return Observer(
      builder: (context) {
        final signInStatus = _store.signInFeature.status;

        return Stack(
          children: [
            ReactiveForm(
              formGroup: _signInForm,
              child:
                  Column(
                        children: [
                          EasyText(
                            LocaleKeys.signIn.tr(),
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ).padding(bottom: 20),
                          SocialLoginButton(
                            onPressed: signInStatus == FutureStatus.pending
                                ? null
                                : () {
                                    _analyticsStore.logEvent(AnalyticsEvent.appleLogin);
                                    _store.signInWithApple();
                                  },
                            isLoading:
                                signInStatus == FutureStatus.pending &&
                                _store.authenticatingType == GrantType.apple,
                            asset: Asset.icons.apple,
                            label: LocaleKeys.continueWithApple.tr(),
                          ).padding(bottom: 20),
                          SocialLoginButton(
                            onPressed: signInStatus == FutureStatus.pending
                                ? null
                                : () {
                                    _analyticsStore.logEvent(AnalyticsEvent.gLogin);
                                    _store.signInWithGoogle();
                                  },
                            isLoading:
                                signInStatus == FutureStatus.pending &&
                                _store.authenticatingType == GrantType.google,
                            asset: Asset.icons.google,
                            label: LocaleKeys.continueWithGoogle.tr(),
                          ),
                          Row(
                            children: [
                              const Expanded(child: Divider(color: Palette.lightBlack)),
                              EasyText(
                                LocaleKeys.or.tr(),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Palette.lightBlack,
                              ).padding(horizontal: 8),
                              const Expanded(child: Divider(color: Palette.lightBlack)),
                            ],
                          ).padding(vertical: height * 0.03),
                          AutofillGroup(
                            child: ReactiveTextField(
                              key: K.loginEmailField,
                              onTap: (_) {
                                _analyticsStore.logEvent(AnalyticsEvent.emailInput);
                              },
                              onTapOutside: (_) =>
                                  FocusScope.of(context, createDependency: false).unfocus(),
                              decoration: InputDecoration(
                                labelText: LocaleKeys.email.tr(),
                                hintText: 'example@example.com',
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                              formControlName: 'email',
                              autofillHints: const [AutofillHints.email],
                              keyboardType: TextInputType.emailAddress,
                              onSubmitted: (_) =>
                                  FocusScope.of(context, createDependency: false).unfocus(),
                              onEditingComplete: (_) => TextInput.finishAutofillContext(),
                              validationMessages: {
                                ValidationMessage.required: (_) => LocaleKeys.emailIsRequired.tr(),
                                ValidationMessage.email: (_) => LocaleKeys.emailIsNotValid.tr(),
                              },
                            ).padding(bottom: 10),
                          ),
                          ReactiveFormConsumer(
                            builder: (_, signInForm, child) => EasyButton(
                              key: K.loginButton,
                              width: double.infinity,
                              onPressed: signInStatus != FutureStatus.pending
                                  ? () => _onSignInWithEmailPressed(
                                      signInForm,
                                      context,
                                      _store,
                                      _analyticsStore,
                                    )
                                  : null,
                              child:
                                  signInStatus == FutureStatus.pending &&
                                      _store.authenticatingType == GrantType.email
                                  ? const LoadingIndicator()
                                  : EasyText(
                                      LocaleKeys.continueWithEmail.tr(),
                                      color: Palette.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                            ),
                          ).padding(bottom: height * 0.03),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14),
                              children: [
                                TextSpan(text: '${LocaleKeys.signInDisclaimer.tr()} '),
                                TextSpan(
                                  text: LocaleKeys.termsAndConditions.tr(),
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Palette.pink,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  mouseCursor: WidgetStateMouseCursor.clickable,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      openUrlLink(Uri.parse(termsOfServiceUrl));
                                      _analyticsStore.logEvent(AnalyticsEvent.tcsClickLoginScreen);
                                    },
                                ),
                                TextSpan(text: '${LocaleKeys.and.tr()} '),
                                TextSpan(
                                  text: LocaleKeys.privacyPolicy.tr(),
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Palette.pink,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  mouseCursor: WidgetStateMouseCursor.clickable,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      openUrlLink(Uri.parse(privacyPolicyUrl));
                                      _analyticsStore.logEvent(AnalyticsEvent.ppClickLoginScreen);
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                      .padding(
                        top: 20,
                        bottom: 10,
                        horizontal: getMediaWidth(context) > 650 ? 60 : 20,
                      )
                      .scrollable(),
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
    analyticsStore.logEvent(AnalyticsEvent.emailLogin, parameters: {'valid': form.valid});
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    TextInput.finishAutofillContext();
    final email = form.control('email').value as String;
    final result = await store.signInwithEmail(email: email);
    if (context.mounted && result == null) {
      context.beamToNamed(Routes.checkYourEmail.path);
    }
  }
}
