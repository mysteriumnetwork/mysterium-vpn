import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Tooltip;
import 'package:google_fonts/google_fonts.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/components/spans/character_span.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/components/tooltip.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';

class UserIntentTooltip extends StatelessWidget {
  const UserIntentTooltip({super.key});

  @override
  Widget build(BuildContext context) => Tooltip(
    type: TooltipType.userIntent,
    autoDismissDuration: null,
    buildEntry: (ctx) => TooltipEntry(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: _Body(),
    ),
    child: SvgIcon(asset: Asset.icons.infoCircle(context)),
  );
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    spacing: 20,
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [for (final value in UserIntent.values) _Item(value: value)],
  );
}

class _Item extends StatelessWidget {
  const _Item({required this.value});

  final UserIntent value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = GoogleFonts.montserrat(fontSize: 12, color: theme.textTheme.bodyLarge?.color);
    return AutoSizeText.rich(
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
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
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
      style: textStyle,
    );
  }
}
