import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/headline_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginHeadlines extends HookConsumerWidget {
  const LoginHeadlines({super.key, this.crossAxisAlignment = CrossAxisAlignment.start});
  final CrossAxisAlignment crossAxisAlignment;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: [
            HeadlineText(
              text: LocaleKeys.anonymous.tr(),
              color: Palette.purple,
            ),
            HeadlineText(
              text: LocaleKeys.affordable.tr(),
            ),
            HeadlineText(
              text: LocaleKeys.fast.tr(),
            ),
            HeadlineText(
              text: LocaleKeys.secure.tr(),
            ),
            HeadlineText(
              text: LocaleKeys.loginQuote.tr(),
              maxLines: 2,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ).padding(vertical: 20),
          ],
        ),
      ),
    );
  }
}
