import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/constants/constants.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

class Agreements extends StatelessWidget {
  const Agreements({required this.analyticsStore, super.key});

  final AnalyticsStore analyticsStore;
  @override
  Widget build(BuildContext context) => RichText(
    maxLines: 2,
    textAlign: TextAlign.center,
    text: TextSpan(
      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 14),
      children: [
        TextSpan(text: LocaleKeys.readOur.tr()),
        TextSpan(
          text: LocaleKeys.privacyPolicy.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Palette.pink,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          mouseCursor: WidgetStateMouseCursor.clickable,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              analyticsStore.logEvent(AnalyticsEvent.ppClick);
              openUrlLink(Uri.parse(privacyPolicyUrl));
            },
        ),
        TextSpan(text: LocaleKeys.and.tr()),
        TextSpan(
          text: LocaleKeys.termsAndConditions.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Palette.pink,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          mouseCursor: WidgetStateMouseCursor.clickable,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              analyticsStore.logEvent(AnalyticsEvent.tcsClick);
              openUrlLink(Uri.parse(termsOfServiceUrl));
            },
        ),
        TextSpan(text: LocaleKeys.moreInfo.tr()),
      ],
    ),
  );
}
