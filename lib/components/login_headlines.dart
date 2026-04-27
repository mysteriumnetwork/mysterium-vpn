import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginHeadlines extends HookConsumerWidget {
  const LoginHeadlines({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => FittedBox(
    fit: BoxFit.scaleDown,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HeadlineText(text: LocaleKeys.anonymous.tr(), color: Palette.brand),
        HeadlineText(text: LocaleKeys.affordable.tr()),
        HeadlineText(text: LocaleKeys.fast.tr()),
        HeadlineText(text: LocaleKeys.secure.tr()),
        HeadlineText(
          text: LocaleKeys.loginQuote.tr(),
          maxLines: 3,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ).padding(vertical: getMediaHeight(context) * 0.02),
      ],
    ),
  );
}
