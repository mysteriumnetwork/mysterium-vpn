// ignore_for_file: use_build_context_synchronously

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/dialogs/info_dialog.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/header_title.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';
import 'package:mysterium_vpn/stores/vpn/i_vpn.dart';
import 'package:styled_widget/styled_widget.dart';

Future<void> shownDeleteAccountDialog(
  BuildContext context, {
  required AuthStore authStore,
  required IVpnStore vpnStore,
  required AnalyticsStore analyticsStore,
}) async {
  analyticsStore.logEvent(AnalyticsEvent.deleteAccountPopup);
  showModalBottomSheet(
    clipBehavior: Clip.none,
    constraints: const BoxConstraints.tightFor(width: double.infinity),
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).primaryColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: _DeleteAccountDialog(
        authStore: authStore,
        analyticsStore: analyticsStore,
        vpnStore: vpnStore,
      ),
    ),
  );
}

class _DeleteAccountDialog extends HookWidget {
  const _DeleteAccountDialog({
    required this.authStore,
    required this.analyticsStore,
    required this.vpnStore,
  });

  final AuthStore authStore;
  final AnalyticsStore analyticsStore;
  final IVpnStore vpnStore;

  @override
  Widget build(BuildContext context) {
    final confirmationMessage = useState('');
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
          top: -15,
          child: SvgIcon(
            asset: Asset.icons.warning,
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
                  color: context.c.isDarkMode ? Palette.veryLightGrey : Palette.black,
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
                onTap: () {
                  analyticsStore.logEvent(AnalyticsEvent.deleteAccountInput);
                },
                onTapOutside: (_) => FocusScope.of(
                  context,
                  createDependency: false,
                ).unfocus(),
              ).height(40).padding(bottom: 30),
              EasyButton(
                useSystemColor: false,
                width: 160,
                color: Palette.pink,
                onPressed: confirmationMessage.value == 'DELETE' &&
                        authStore.deleteAccountFeature.status != FutureStatus.pending
                    ? () async {
                        analyticsStore.logEvent(AnalyticsEvent.deleteAccountConfirm);
                        await authStore.deleteAccount();
                        if (context.mounted) {
                          await Beamer.of(context).popRoute();
                          shownInfoDialog(
                            context,
                            LocaleKeys.accountSuccessfullyDeleted.tr(),
                            isDismissible: false,
                            messages: [
                              LocaleKeys.redirectToLoginPage.tr(),
                            ],
                            onConfirm: () async {
                              await vpnStore.disconnectFromVpn();
                              authStore.logout();
                            },
                          );
                        }
                      }
                    : null,
                child: authStore.deleteAccountFeature.status == FutureStatus.pending
                    ? const LoadingIndicator(
                        indicatorColor: Palette.white,
                      ).paddingDirectional(end: 4)
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
