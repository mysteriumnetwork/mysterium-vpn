import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/forms/forms.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignInForm extends HookConsumerWidget {
  const SignInForm({super.key});

  static const double _maxContentWidth = 360;
  static const double _mobileBottomGap = 32;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);
    final store = ref.watch(authStorePOD);
    final signInForm = useMemoized(singIn);

    useEffect(() {
      Future.microtask(() async {
        final email = await store.getLastLoggedInUser();
        if (!signInForm.control('email').dirty) {
          signInForm.control('email').value = email;
        }
      });
      return null;
    }, [signInForm, store]);

    return Observer(
      builder: (context) {
        final signInStatus = store.signInFeature.status;
        final theme = Theme.of(context);
        final palette = theme.palette;
        final textStyles = theme.textStyles;
        final spacing = theme.spacing;
        final isDesktop = ScreenType.of(context) >= ScreenType.tablet;

        const brand = _Brand();

        final formContent = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              LocaleKeys.loginSignupLabel.tr(),
              textAlign: TextAlign.center,
              style: textStyles.displayXlg.semibold.copyWith(color: palette.textPrimary),
            ),
            SizedBox(height: spacing.xl3),
            SocialLoginButton(
              onPressed: signInStatus == FutureStatus.pending
                  ? null
                  : () {
                      analyticsStore.logEvent(AnalyticsEvent.appleLogin);
                      store.signInWithApple();
                    },
              isLoading:
                  signInStatus == FutureStatus.pending &&
                  store.authenticatingType == GrantType.apple,
              asset: Asset.icons.apple,
              iconColor: palette.iconPrimary,
              label: LocaleKeys.continueWithApple.tr(),
            ),
            SizedBox(height: spacing.s),
            SocialLoginButton(
              onPressed: signInStatus == FutureStatus.pending
                  ? null
                  : () {
                      analyticsStore.logEvent(AnalyticsEvent.gLogin);
                      store.signInWithGoogle();
                    },
              isLoading:
                  signInStatus == FutureStatus.pending &&
                  store.authenticatingType == GrantType.google,
              asset: Asset.icons.google,
              label: LocaleKeys.continueWithGoogle.tr(),
            ),
            SizedBox(height: spacing.xl2),
            _OrDivider(),
            SizedBox(height: spacing.xl2),
            _EmailField(analyticsStore: analyticsStore),
          ],
        );

        final actions = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ReactiveFormConsumer(
              builder: (_, form, _) => ButtonPrimary(
                key: K.loginButton,
                onPressed: () => _onSignInWithEmailPressed(form, context, store, analyticsStore),
                loading:
                    signInStatus == FutureStatus.pending &&
                        store.authenticatingType == GrantType.email
                    ? const ButtonLoading()
                    : null,
                decoration: const ButtonDecoration(minimumSize: Size(double.infinity, 44)),
                child: Text(LocaleKeys.continueWithEmail.tr()),
              ),
            ),
            SizedBox(height: spacing.md),
            _Disclaimer(analyticsStore: analyticsStore),
          ],
        );

        final layout = isDesktop
            ? _DesktopLayout(
                maxWidth: _maxContentWidth,
                gap: spacing.xl3,
                brand: brand,
                formContent: formContent,
                actions: actions,
              )
            : _MobileLayout(
                hPad: spacing.md,
                bottomGap: _mobileBottomGap,
                brand: brand,
                formContent: formContent,
                actions: actions,
              );

        return ReactiveForm(formGroup: signInForm, child: layout);
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

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.maxWidth,
    required this.gap,
    required this.brand,
    required this.formContent,
    required this.actions,
  });

  final double maxWidth;
  final double gap;
  final Widget brand;
  final Widget formContent;
  final Widget actions;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            brand,
            SizedBox(height: gap),
            formContent,
            SizedBox(height: gap),
            actions,
          ],
        ),
      ),
    ),
  );
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.hPad,
    required this.bottomGap,
    required this.brand,
    required this.formContent,
    required this.actions,
  });

  final double hPad;
  final double bottomGap;
  final Widget brand;
  final Widget formContent;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).spacing;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                brand,
                SizedBox(height: spacing.xl3),
                formContent,
              ],
            ),
          ),
        ),
        Padding(padding: EdgeInsets.fromLTRB(hPad, 0, hPad, bottomGap), child: actions),
      ],
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) => Center(child: Asset.logo.logoStacked(context).svg());
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final textStyles = theme.textStyles;

    return Row(
      children: [
        Expanded(child: Divider(color: palette.bgSecondaryDisabled)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.spacing.s),
          child: Text(
            LocaleKeys.or.tr(),
            style: textStyles.textXs.regular.copyWith(color: palette.textTertiary),
          ),
        ),
        Expanded(child: Divider(color: palette.bgSecondaryDisabled)),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({required this.analyticsStore});

  final AnalyticsStore analyticsStore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final textStyles = theme.textStyles;
    final spacing = theme.spacing;

    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.email.tr(),
            style: textStyles.textSm.medium.copyWith(color: palette.textSecondary),
          ),
          SizedBox(height: spacing.s),
          ReactiveTextField(
            key: K.loginEmailField,
            onTap: (_) => analyticsStore.logEvent(AnalyticsEvent.emailInput),
            onTapOutside: (_) => FocusScope.of(context, createDependency: false).unfocus(),
            style: textStyles.textSm.regular.copyWith(color: palette.textPrimary),
            decoration: InputDecoration(
              hintText: 'example@example.com',
              hintStyle: textStyles.textSm.regular.copyWith(color: palette.textTertiary),
              filled: true,
              fillColor: palette.bgPrimary,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: spacing.ms, vertical: spacing.s),
              constraints: const BoxConstraints(minHeight: 40),
              border: _inputBorder(palette.borderPrimary),
              enabledBorder: _inputBorder(palette.borderPrimary),
              focusedBorder: _inputBorder(palette.borderBrand),
              errorBorder: _inputBorder(palette.borderError),
              focusedErrorBorder: _inputBorder(palette.borderError),
            ),
            formControlName: 'email',
            autofillHints: const [AutofillHints.email],
            keyboardType: TextInputType.emailAddress,
            onSubmitted: (_) => FocusScope.of(context, createDependency: false).unfocus(),
            onEditingComplete: (_) => TextInput.finishAutofillContext(),
            validationMessages: {
              ValidationMessage.required: (_) => LocaleKeys.emailIsRequired.tr(),
              ValidationMessage.email: (_) => LocaleKeys.emailIsNotValid.tr(),
            },
          ),
        ],
      ),
    );
  }
}

class _Disclaimer extends StatefulWidget {
  const _Disclaimer({required this.analyticsStore});

  final AnalyticsStore analyticsStore;

  @override
  State<_Disclaimer> createState() => _DisclaimerState();
}

class _DisclaimerState extends State<_Disclaimer> {
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () {
        openUrlLink(Uri.parse(termsOfServiceUrl));
        widget.analyticsStore.logEvent(AnalyticsEvent.tcsClickLoginScreen);
      };
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        openUrlLink(Uri.parse(privacyPolicyUrl));
        widget.analyticsStore.logEvent(AnalyticsEvent.ppClickLoginScreen);
      };
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final textStyles = theme.textStyles;
    final baseStyle = textStyles.textXs.regular.copyWith(color: palette.textTertiary);
    final linkStyle = baseStyle.copyWith(decoration: TextDecoration.underline);

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: '${LocaleKeys.signInDisclaimer.tr()} '),
          TextSpan(
            text: LocaleKeys.termsAndConditions.tr(),
            style: linkStyle,
            mouseCursor: WidgetStateMouseCursor.clickable,
            recognizer: _termsRecognizer,
          ),
          TextSpan(text: ' ${LocaleKeys.and.tr()} '),
          TextSpan(
            text: LocaleKeys.privacyPolicy.tr(),
            style: linkStyle,
            mouseCursor: WidgetStateMouseCursor.clickable,
            recognizer: _privacyRecognizer,
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}

OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
  borderRadius: const BorderRadius.all(Radius.kXs),
  borderSide: BorderSide(color: color),
);
