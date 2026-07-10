import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class SubscriptionPrivacyAndTerms extends StatelessWidget {
  const SubscriptionPrivacyAndTerms({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textStyles.textSm.regular.copyWith(color: theme.palette.textSecondary);

    void handleShowPrivacyPolicy() {
      openUrlLink(Uri.parse(privacyPolicyUrl), source: RedirectSource.privacyPolicy);
    }

    void handleShowTermsAndConditions() {
      openUrlLink(Uri.parse(termsOfServiceUrl), source: RedirectSource.termsOfService);
    }

    return Text.rich(
      TextSpan(
        children: [
          LinkSpan(text: S.current.privacyPolicy, onTap: handleShowPrivacyPolicy, style: style),
          TextSpan(text: S.current.and),
          LinkSpan(
            text: S.current.termsAndConditions,
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
