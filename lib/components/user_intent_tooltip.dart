import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class UserIntentTooltip extends StatelessWidget {
  const UserIntentTooltip({super.key});

  @override
  Widget build(BuildContext context) => TooltipIcon.widget(content: _Body());
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    spacing: Theme.of(context).spacing.ms,
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [for (final value in UserIntent.values) _Item(value: value)],
  );
}

class _Item extends StatelessWidget {
  const _Item({required this.value});

  final UserIntent value;

  @override
  Widget build(BuildContext context) => AutoSizeText.rich(
    TextSpan(
      children: [
        TextSpan(
          text: switch (value) {
            UserIntent.bestSpeed => LocaleKeys.userIntentBestSpeed.tr(),
            UserIntent.lowLatency => LocaleKeys.userIntentLowLatency.tr(),
            UserIntent.nearestLocation => LocaleKeys.userIntentNearestLocation.tr(),
            UserIntent.maxPrivacy => LocaleKeys.userIntentMaxPrivacy.tr(),
            UserIntent.streaming => LocaleKeys.userIntentStreaming.tr(),
            UserIntent.p2p => LocaleKeys.userIntentP2P.tr(),
          },
          style: Theme.of(
            context,
          ).textStyles.textXs.bold.copyWith(color: Theme.of(context).palette.textTooltip),
        ),
        CharacterSpan.space(),
        CharacterSpan.hyphen(),
        CharacterSpan.space(),
        TextSpan(
          text: switch (value) {
            UserIntent.bestSpeed => LocaleKeys.userIntentBestSpeedDesc.tr(),
            UserIntent.lowLatency => LocaleKeys.userIntentLowLatencyDesc.tr(),
            UserIntent.nearestLocation => LocaleKeys.userIntentNearestLocationDesc.tr(),
            UserIntent.maxPrivacy => LocaleKeys.userIntentMaxPrivacyDesc.tr(),
            UserIntent.streaming => LocaleKeys.userIntentStreamingDesc.tr(),
            UserIntent.p2p => LocaleKeys.userIntentP2PDesc.tr(),
          },
        ),
      ],
    ),
  );
}
