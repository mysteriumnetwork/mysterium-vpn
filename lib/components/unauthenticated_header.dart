import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class UnauthenticatedHeader extends HookConsumerWidget {
  const UnauthenticatedHeader({this.backLabel, super.key});

  /// When user can browse the app without authentication, show back button with [backLabel]. Otherwise, hide back button and label.
  final String? backLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final authSessionStore = ref.read(authSessionStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);
    final canBrowseApp = useComputedValue(() => authSessionStore.canBrowseApp);

    Future<void> handleClose() async {
      Beamer.of(context).beamToNamed(Routes.main.path);
    }

    return Header(
      backgroundColor: palette.bgSidePanel,
      showBackButton: canBrowseApp,
      backLabel: canBrowseApp ? backLabel ?? LocaleKeys.back.tr() : null,
      onBackPressed: canBrowseApp ? handleClose : null,
      actions: [
        IconButton(
          onPressed: () => handleOnSupportPage(context: context, analyticsStore: analyticsStore),
          icon: Icon(UntitledUI.message_question_square, size: 24, color: palette.iconPrimary),
        ),
      ],
    );
  }
}
