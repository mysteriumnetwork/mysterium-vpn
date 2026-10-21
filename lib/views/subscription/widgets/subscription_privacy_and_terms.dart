import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/ui/ui.dart';
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

    return LinkText(
      style: style,
      textAlign: TextAlign.center,
      builder: (link) => [
        link(S.current.privacyPolicy, handleShowPrivacyPolicy),
        TextSpan(text: S.current.and),
        link(S.current.termsAndConditions, handleShowTermsAndConditions),
      ],
    );
  }
}
