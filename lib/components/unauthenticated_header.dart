import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class UnauthenticatedHeader extends HookConsumerWidget {
  const UnauthenticatedHeader({this.backHeader = false, super.key});

  /// When true, shows a back arrow + "Back" label on the left.
  final bool backHeader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final authSessionStore = ref.read(authSessionStorePOD);
    final canBrowseApp = useComputedValue(() => authSessionStore.canBrowseApp);

    Future<void> handleClose() async {
      Beamer.of(context).beamToNamed(Routes.main.path);
    }

    return Header(
      backgroundColor: palette.bgSidePanel,
      showBackButton: backHeader,
      backLabel: backHeader ? LocaleKeys.back.tr() : null,
      actions: [
        if (canBrowseApp)
          CustomIconButton(
            onPressed: handleClose,
            minimumSize: const Size(32, 32),
            icon: Icon(UntitledUI.x_close, size: 24, color: palette.iconPrimary),
          ),
      ],
    );
  }
}
