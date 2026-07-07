import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({required this.onSignIn, super.key});

  static const double _imageSize = 236;

  // Approximated heights of fixed-size children, used only to size the
  // responsive top/bottom gaps. Order: Header, Brand, displayXlg line, image,
  // ButtonPrimary, plus the rigid token gaps.
  static const double _fixedChildren = 64 + 66 + 38 + _imageSize + 44;

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final fixed = _fixedChildren + theme.spacing.md + theme.spacing.xl + theme.spacing.xl3;

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = (constraints.maxHeight - fixed).clamp(0.0, double.infinity);
        final topGap = (available * 3 / 8).clamp(0.0, 60.0);
        final bottomGap = (available * 5 / 8).clamp(0.0, 100.0);

        return Column(
          children: [
            UnauthenticatedHeader(backLabel: S.current.homeLbl),
            const Brand(),
            SizedBox(height: topGap),
            Text(
              S.current.takeBackTheInternetLbl,
              style: theme.textStyles.displayXlg.semibold.copyWith(color: palette.textPrimary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: theme.spacing.xl),
            Asset.images.welcome.image(width: _imageSize),
            SizedBox(height: theme.spacing.xl3),
            const Spacer(),
            ButtonPrimary(onPressed: onSignIn, child: Text(S.current.signIn)),
            SizedBox(height: bottomGap),
          ],
        );
      },
    );
  }
}
