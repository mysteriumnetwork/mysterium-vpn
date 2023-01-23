import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/headline_text.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginHeadlines extends HookConsumerWidget {
  const LoginHeadlines(
      {super.key, this.crossAxisAlignment = CrossAxisAlignment.start});
  final CrossAxisAlignment crossAxisAlignment;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loco = ref.watch(localeStorePOD).loco;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: [
            HeadlineText(
              text: loco.anonymous,
              color: Palette.purple,
            ),
            HeadlineText(
              text: loco.affordable,
            ),
            HeadlineText(
              text: loco.fast,
            ),
            HeadlineText(
              text: loco.secure,
            ),
            HeadlineText(
              text: loco.login_quote,
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
