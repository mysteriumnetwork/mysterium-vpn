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
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
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
        final textStyles = Theme.of(context).textStyles;
        final palette = Theme.of(context).palette;
        final spacing = Theme.of(context).spacing;

        return Stack(
          children: [
            ReactiveForm(
              formGroup: _signInForm,
              child:
                  Column(
                        children: [
                          Text(
                            LocaleKeys.signIn.tr(),
                            style: textStyles.displayXlg.bold,
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
                            iconColor: palette.iconPrimary,
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
                              Expanded(child: Divider(color: palette.textTertiary)),
                              Text(
                                LocaleKeys.or.tr(),
                                style: textStyles.textMd.bold.copyWith(color: palette.textTertiary),
                              ).padding(horizontal: 8),
                              Expanded(child: Divider(color: palette.textTertiary)),
                            ],
                          ).padding(vertical: height * 0.03),
                          AutofillGroup(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.email.tr(),
                                  style: textStyles.textSm.medium.copyWith(
                                    color: palette.textSecondary,
                                  ),
                                ),
                                SizedBox(height: spacing.s),
                                ReactiveTextField(
                                  key: K.loginEmailField,
                                  onTap: (_) {
                                    _analyticsStore.logEvent(AnalyticsEvent.emailInput);
                                  },
                                  onTapOutside: (_) =>
                                      FocusScope.of(context, createDependency: false).unfocus(),
                                  style: textStyles.textSm.regular.copyWith(
                                    color: palette.textPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'example@example.com',
                                    hintStyle: textStyles.textSm.regular.copyWith(
                                      color: palette.textTertiary,
                                    ),
                                    filled: true,
                                    fillColor: palette.bgPrimary,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: spacing.md,
                                      vertical: spacing.md,
                                    ),
                                    constraints: BoxConstraints(minHeight: spacing.xl4),
                                    border: _inputBorder(palette.borderPrimary),
                                    enabledBorder: _inputBorder(palette.borderPrimary),
                                    focusedBorder: _inputBorder(palette.borderBrand),
                                    errorBorder: _inputBorder(palette.borderError),
                                    focusedErrorBorder: _inputBorder(palette.borderError),
                                  ),
                                  formControlName: 'email',
                                  autofillHints: const [AutofillHints.email],
                                  keyboardType: TextInputType.emailAddress,
                                  onSubmitted: (_) =>
                                      FocusScope.of(context, createDependency: false).unfocus(),
                                  onEditingComplete: (_) => TextInput.finishAutofillContext(),
                                  validationMessages: {
                                    ValidationMessage.required: (_) =>
                                        LocaleKeys.emailIsRequired.tr(),
                                    ValidationMessage.email: (_) => LocaleKeys.emailIsNotValid.tr(),
                                  },
                                ),
                              ],
                            ).padding(bottom: 10),
                          ),
                          ReactiveFormConsumer(
                            builder: (_, signInForm, child) => SizedBox(
                              width: double.infinity,
                              child: ButtonPrimary(
                                key: K.loginButton,
                                onPressed: () => _onSignInWithEmailPressed(
                                  signInForm,
                                  context,
                                  _store,
                                  _analyticsStore,
                                ),
                                loading:
                                    signInStatus == FutureStatus.pending &&
                                        _store.authenticatingType == GrantType.email
                                    ? const ButtonLoading()
                                    : null,
                                child: Text(LocaleKeys.continueWithEmail.tr()),
                              ),
                            ),
                          ).padding(bottom: height * 0.03, top: height * 0.01),
                          RichText(
                            text: TextSpan(
                              style: textStyles.textSm.regular,
                              children: [
                                TextSpan(text: '${LocaleKeys.signInDisclaimer.tr()} '),
                                TextSpan(
                                  text: LocaleKeys.termsAndConditions.tr(),
                                  style: textStyles.textSm.bold.copyWith(
                                    color: palette.textBrandPrimary,
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
                                  style: textStyles.textSm.bold.copyWith(
                                    color: palette.textBrandPrimary,
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

OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
  borderRadius: const BorderRadius.all(Radius.kS),
  borderSide: BorderSide(color: color),
);
