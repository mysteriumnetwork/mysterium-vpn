import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/shared/components/app_logo.dart';
import 'package:mysterium_vpn/shared/components/svg_icon_button.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class UnauthenticatedHeader extends HookConsumerWidget {
  const UnauthenticatedHeader({
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
    super.key,
  });

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSessionStore = ref.read(authSessionStorePOD);
    final canBrowseApp = useComputedValue(() => authSessionStore.canBrowseApp);

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 24,
        children: [
          if (canBrowseApp) const _BackButton(),
          if (!canBrowseApp) const SizedBox.shrink(),
          const Expanded(child: AppLogo()),
          SvgIconButton(
            asset: Asset.icons.supportLight,
            onPressed: () {
              handleOnSupportPage(context: context, analyticsStore: ref.read(analyticsStorePOD));
            },
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    Future<void> handleBackOrHome() async {
      final beamer = Beamer.of(context);
      final success = await beamer.popRoute();
      if (!success) {
        beamer.beamToNamed(Routes.main.path);
      }
    }

    return SvgIconButton(
      key: K.backButton,
      asset: Asset.icons.navigateBackLighter(context),
      onPressed: handleBackOrHome,
    );
  }
}
