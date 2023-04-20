import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/dialogs/adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:mysterium_vpn/components/dialogs/no_mail_app_dialog.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:styled_widget/styled_widget.dart';

class CheckYourEmailView extends HookConsumerWidget {
  const CheckYourEmailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStore = ref.watch(authStorePOD);
    final isMounted = useIsMounted();

    return Scaffold(
      body: SafeArea(
        child: Observer(
          builder: (context) => Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EasyText(
                    LocaleKeys.checkYourEmail.tr(),
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ).padding(bottom: 60, top: 20),
                  const SvgIcon(
                    asset: Assets.checkEmail,
                  ).padding(bottom: 40),
                  EasyText(
                    LocaleKeys.emailSentTo.tr(namedArgs: {'email': authStore.email}),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ).padding(bottom: 20),
                  EasyText(
                    LocaleKeys.linkExpires.tr(),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ).padding(bottom: 20),
                  EasyText(
                    LocaleKeys.consumeLink.tr(),
                    maxLines: 5,
                    textAlign: TextAlign.center,
                  ).padding(bottom: 50),
                  EasyButton(
                    text: LocaleKeys.openEmailApp.tr(),
                    onPressed: () => openEmailApp(context, isMounted),
                  ),
                ],
              ).scrollable().padding(all: 20),
              if (authStore.authStatus == AuthStatus.authenticating)
                LoadingBarrier(color: Theme.of(context).primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openEmailApp(
    BuildContext context,
    bool Function() isMounted,
  ) async {
    final result = await OpenMailApp.openMailApp(
      nativePickerTitle: LocaleKeys.selectEmailApp.tr(),
    );
    if (!result.didOpen && !result.canOpen && isMounted()) {
      // ignore: use_build_context_synchronously
      shownNoMailAppDialog(context);
    } else if (!result.didOpen && result.canOpen && isMounted()) {
      final actions = result.options
          .map(
            (option) => BottomSheetAction(
              title: option.name,
              onPressed: (_) => OpenMailApp.openSpecificMailApp(option),
            ),
          )
          .toList();
      // ignore: use_build_context_synchronously
      showAdaptiveActionSheet(
        title: Text(LocaleKeys.selectEmailApp.tr()),
        context: context,
        actions: [...actions],
        cancelAction: CancelAction(title: LocaleKeys.cancelBtn.tr()),
      );
    }
  }

  Widget createListView(BuildContext context, List<MailApp> values) => ListView.builder(
        shrinkWrap: true,
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) => Column(
          children: <Widget>[
            CupertinoActionSheetAction(child: EasyText(values[index].name), onPressed: () {}),
          ],
        ),
      );
}
