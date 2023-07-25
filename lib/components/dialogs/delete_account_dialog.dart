// ignore_for_file: use_build_context_synchronously

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/dialogs/info_dialog.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/header_title.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';
import 'package:styled_widget/styled_widget.dart';

Future<void> shownDeleteAccountDialog(BuildContext context, AuthStore store) async {
  showModalBottomSheet(
    clipBehavior: Clip.none,
    constraints: const BoxConstraints.tightFor(width: double.infinity),
    context: context,
    backgroundColor: Theme.of(context).primaryColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.zero,
      child: _DeleteAccountDialog(store: store),
    ),
  );
}

class _DeleteAccountDialog extends HookWidget {
  const _DeleteAccountDialog({required this.store});
  final AuthStore store;
  @override
  Widget build(BuildContext context) {
    final confirmationMessage = useState('');
    final isMounted = useIsMounted();
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        const Positioned(
          top: -15,
          child: SvgIcon(
            asset: Assets.warning,
          ),
        ),
        Observer(
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HeaderTitle(
                text: LocaleKeys.deleteAccountQuestion.tr(),
              ),
              EasyText(
                LocaleKeys.cancelYourSubsMess.tr(),
                fontSize: 14,
                maxLines: 3,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
              ).padding(bottom: 30),
              EasyText(
                LocaleKeys.typeDelete.tr(),
                fontSize: 14,
                maxLines: 3,
              ).padding(bottom: 10),
              TextField(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.brightness == Brightness.light
                      ? Palette.black
                      : Palette.veryLightGrey,
                ),
                decoration: InputDecoration(
                  filled: true,
                  contentPadding: const EdgeInsets.only(left: 20),
                  fillColor: Theme.of(context).colorScheme.surface,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Palette.lightBlue),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Palette.lightBlue),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                onChanged: (val) => confirmationMessage.value = val,
                autocorrect: false,
              ).height(40).padding(bottom: 30),
              EasyButton(
                useSystemColor: false,
                width: 160,
                color: Palette.pink,
                onPressed:
                    confirmationMessage.value == 'DELETE' && store.deleteAccountFeature.status != FutureStatus.pending
                        ? () async {
                            await store.deleteAccount();
                            if (isMounted()) {
                              await Beamer.of(context).popRoute();
                              shownInfoDialog(
                                context,
                                LocaleKeys.accountSuccessfullyDeleted.tr(),
                                isDismissible: false,
                                messages: [
                                  LocaleKeys.redirectToLoginPage.tr(),
                                ],
                                onConfirm: store.logout,
                              );
                            }
                          }
                        : null,
                child: store.deleteAccountFeature.status == FutureStatus.pending
                    ? const LoadingIndicator(
                        radius: 20,
                        strokeWidth: 1.5,
                        indicatorColor: Palette.white,
                      ).padding(right: 4)
                    : EasyText(
                        LocaleKeys.confirm.tr(),
                        color: Palette.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
              ),
            ],
          ).padding(horizontal: 20, vertical: 40),
        ),
      ],
    );
  }
}
