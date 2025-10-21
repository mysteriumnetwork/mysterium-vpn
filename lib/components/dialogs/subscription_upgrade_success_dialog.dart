import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/modal_page_scaffold.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

Future<void> showSubscriptionUpgradeSuccessDialog(BuildContext context) async {
  await showModalPage(
    context,
    builder: (_) => const _Page(),
  );
}

class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) {
    void handleGoHome() {
      final beamer = Beamer.of(context);
      final navigator = Navigator.of(context);

      // clear navigation history
      while (beamer.removeLastHistoryElement() != null) {}
      // go to home
      beamer.beamToNamed(Routes.main.path);
      // close modal
      navigator.pop();
    }

    return ModalPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: DefaultTextStyle(
              style: const TextStyle(),
              textAlign: TextAlign.center,
              child: Column(
                spacing: 24,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Asset.icons.successCup(context).svg(),
                  EasyText(
                    LocaleKeys.subscriptionUpgradeSuccessTitle.tr(),
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                  ),
                  EasyText(
                    LocaleKeys.subscriptionUpgradeSuccessMessage.tr(args: ['1-year']),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          EasyButton(
            onPressed: handleGoHome,
            text: 'Go to home',
            useSystemColor: false,
            color: Palette.purple,
          ),
        ],
      ),
    );
  }
}
