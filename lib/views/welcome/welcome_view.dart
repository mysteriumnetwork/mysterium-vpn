import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/url_launcher.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class WelcomeView extends HookConsumerWidget {
  const WelcomeView({required this.onSignIn, super.key});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final analyticsStore = ref.read(analyticsStorePOD);
    final authSessionStore = ref.read(authSessionStorePOD);
    final canBrowseApp = useComputedValue(() => authSessionStore.canBrowseApp);

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = (constraints.maxHeight - _fixedContentHeight(theme)).clamp(
          0.0,
          double.infinity,
        );
        final topGap = (available * 3 / 8).clamp(0.0, 60.0);
        final bottomGap = (available * 5 / 8).clamp(0.0, 100.0);

        return Column(
          children: [
            Header(
              backgroundColor: palette.bgSidePanel,
              showBackButton: canBrowseApp,
              backLabel: LocaleKeys.homeLbl.tr(),
              onBackPressed: () => Beamer.of(context).beamToNamed(Routes.main.path),
              actions: [
                CustomIconButton(
                  onPressed: () =>
                      handleOnSupportPage(context: context, analyticsStore: analyticsStore),
                  minimumSize: const Size(32, 32),
                  icon: Icon(
                    UntitledUI.message_question_square,
                    size: 24,
                    color: palette.iconPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: theme.spacing.md),
            const Brand(),
            SizedBox(height: topGap),
            Text(
              LocaleKeys.takeBackTheInternetLbl.tr(),
              style: theme.textStyles.displayXlg.bold.copyWith(color: palette.textPrimary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: theme.spacing.xl),
            Asset.images.welcome.image(width: 236),
            SizedBox(height: theme.spacing.xl3),
            const Spacer(),
            ButtonPrimary(onPressed: onSignIn, child: Text(LocaleKeys.signIn.tr())),
            SizedBox(height: bottomGap),
          ],
        );
      },
    );
  }

  // Approximate non-gap height: header + brand + title line + image + button + token gaps.
  double _fixedContentHeight(ThemeData theme) =>
      64 + 66 + 38 + 236 + 44 + theme.spacing.md + theme.spacing.xl + theme.spacing.xl3;
}
