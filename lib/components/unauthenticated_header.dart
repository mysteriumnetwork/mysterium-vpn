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
  const UnauthenticatedHeader({this.backHeader = false, super.key});

  final bool backHeader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSessionStore = ref.read(authSessionStorePOD);
    final canBrowseApp = useComputedValue(() => authSessionStore.canBrowseApp);
    Future<void> handleBackOrHome() async {
      final beamer = Beamer.of(context);
      final success = await beamer.popRoute();
      if (!success) {
        beamer.beamToNamed(Routes.main.path);
      }
    }

    final designTheme = DesignSystemTheme.of(context);

    return backHeader
        ? Header(backgroundColor: designTheme.palette.bgSidePanel, backLabel: LocaleKeys.back.tr())
        : Header.logo(
            onBackPressed: handleBackOrHome,
            backgroundColor: designTheme.palette.bgSidePanel,
            centerTitle: true,
            showBackButton: canBrowseApp,
            actions: [
              IconButton(
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(32, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(UntitledUI.message_question_square, size: 24),
                onPressed: () => handleOnSupportPage(
                  context: context,
                  analyticsStore: ref.read(analyticsStorePOD),
                ),
              ),
            ],
          );
  }
}
