import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
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
            UserIntent.bestSpeed => S.current.userIntentBestSpeed,
            UserIntent.lowLatency => S.current.userIntentLowLatency,
            UserIntent.nearestLocation => S.current.userIntentNearestLocation,
            UserIntent.maxPrivacy => S.current.userIntentMaxPrivacy,
            UserIntent.streaming => S.current.userIntentStreaming,
            UserIntent.p2p => S.current.userIntentP2P,
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
            UserIntent.bestSpeed => S.current.userIntentBestSpeedDesc,
            UserIntent.lowLatency => S.current.userIntentLowLatencyDesc,
            UserIntent.nearestLocation => S.current.userIntentNearestLocationDesc,
            UserIntent.maxPrivacy => S.current.userIntentMaxPrivacyDesc,
            UserIntent.streaming => S.current.userIntentStreamingDesc,
            UserIntent.p2p => S.current.userIntentP2PDesc,
          },
        ),
      ],
    ),
  );
}
