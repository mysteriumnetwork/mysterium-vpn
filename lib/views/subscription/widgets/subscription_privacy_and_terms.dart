import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionPrivacyAndTerms extends StatelessWidget {
  const SubscriptionPrivacyAndTerms({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textStyles.textSm.regular.copyWith(
      color: theme.palette.textSecondary,
    );

    void handleShowPrivacyPolicy() {
      launchUrl(Uri.parse(privacyPolicyUrl));
    }

    void handleShowTermsAndConditions() {
      launchUrl(Uri.parse(termsOfServiceUrl));
    }

    return Text.rich(
      TextSpan(
        children: [
          LinkSpan(
            text: LocaleKeys.privacyPolicy.tr(),
            onTap: handleShowPrivacyPolicy,
            style: style,
          ),
          TextSpan(text: LocaleKeys.and.tr()),
          LinkSpan(
            text: LocaleKeys.termsAndConditions.tr(),
            onTap: handleShowTermsAndConditions,
            style: style,
          ),
        ],
      ),
      textAlign: TextAlign.center,
      style: style,
    );
  }
}
