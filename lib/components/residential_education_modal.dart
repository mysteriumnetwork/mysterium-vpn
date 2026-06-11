import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Radius;
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Presents the localized [ResidentialEducationModal] as a bottom sheet on
/// mobile or a centred dialog on desktop. Dismisses via Got it / outside tap.
Future<void> showResidentialEducationModal(BuildContext context) async {
  await showBottomSheetDialog<void>(
    context,
    builder: (ctx) => ResidentialEducationModal(
      title: LocaleKeys.residentialEducationTitle.tr(),
      subtitle: LocaleKeys.residentialEducationSubtitle.tr(),
      block1Title: LocaleKeys.residentialEducationBlock1Title.tr(),
      block1Body: LocaleKeys.residentialEducationBlock1Body.tr(),
      block2Title: LocaleKeys.residentialEducationBlock2Title.tr(),
      block2Body: LocaleKeys.residentialEducationBlock2Body.tr(),
      block3Title: LocaleKeys.residentialEducationBlock3Title.tr(),
      block3Body: LocaleKeys.residentialEducationBlock3Body.tr(),
      gotItLabel: LocaleKeys.residentialEducationGotIt.tr(),
      onGotIt: () => Navigator.of(ctx).pop(),
    ),
  );
}

/// Full "How Residential IPs work" education content.
///
/// Presented via [showBottomSheetDialog] — a bottom sheet on mobile (drag
/// handle, no close button) and a centred dialog on desktop (with a ✕). All
/// copy is passed in; the three feature glyphs are fixed.
///
/// App-specific (residential-feature) UI, built on design-system primitives —
/// kept here rather than in the shared design lib.
class ResidentialEducationModal extends StatelessWidget {
  const ResidentialEducationModal({
    required this.title,
    required this.subtitle,
    required this.block1Title,
    required this.block1Body,
    required this.block2Title,
    required this.block2Body,
    required this.block3Title,
    required this.block3Body,
    required this.gotItLabel,
    required this.onGotIt,
    super.key,
  });

  final String title;
  final String subtitle;
  final String block1Title;
  final String block1Body;
  final String block2Title;
  final String block2Body;
  final String block3Title;
  final String block3Body;
  final String gotItLabel;
  final VoidCallback onGotIt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;

    final content = Padding(
      padding: EdgeInsets.fromLTRB(
        theme.spacing.xl2,
        isDesktop ? theme.spacing.xl2 : theme.spacing.md,
        theme.spacing.xl2,
        theme.spacing.xl2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: DecoratedIcon(
              icon: UntitledUI.home_03,
              decoration: IconDecoration(
                backgroundColor: palette.bgSecondarySelected,
                iconSize: 32,
                padding: const EdgeInsets.all(8),
                borderRadius: const BorderRadius.all(Radius.kFull),
              ),
            ),
          ),
          SizedBox(height: theme.spacing.ms),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textStyles.textMd.semibold.copyWith(color: palette.textPrimary),
          ),
          SizedBox(height: theme.spacing.xs),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textStyles.textSm.regular.copyWith(color: palette.textTertiary),
          ),
          SizedBox(height: theme.spacing.xl2),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: theme.spacing.lg,
            children: [
              _Block(icon: UntitledUI.home_03, title: block1Title, body: block1Body),
              _Block(icon: UntitledUI.cloud_off, title: block2Title, body: block2Body),
              _Block(icon: UntitledUI.refresh_cw_02, title: block3Title, body: block3Body),
            ],
          ),
          SizedBox(height: theme.spacing.xl2),
          Align(
            child: ButtonPrimary(onPressed: onGotIt, child: Text(gotItLabel)),
          ),
        ],
      ),
    );

    final surface = ClipRRect(
      borderRadius: isDesktop
          ? BorderRadius.all(theme.radius.xxl)
          : const BorderRadius.vertical(top: Radius.kXl),
      child: ColoredBox(
        color: palette.bgModals,
        child: isDesktop
            ? Stack(
                children: [
                  content,
                  Positioned(
                    top: theme.spacing.s,
                    right: theme.spacing.s,
                    child: IconButton(
                      onPressed: onGotIt,
                      icon: Icon(UntitledUI.x_close, size: 24, color: palette.iconTertiary),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              )
            : content,
      ),
    );

    return surface;
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedIcon(
          icon: icon,
          decoration: IconDecoration(
            backgroundColor: palette.bgInfoIcon,
            iconColor: palette.iconTertiary,
            iconSize: 20,
            padding: const EdgeInsets.all(6),
            borderRadius: const BorderRadius.all(Radius.kFull),
          ),
        ),
        SizedBox(width: theme.spacing.s),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textStyles.textXs.semibold.copyWith(color: palette.textPrimary),
              ),
              SizedBox(height: theme.spacing.xxs),
              Text(
                body,
                style: theme.textStyles.textXs.regular.copyWith(color: palette.textTertiary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
