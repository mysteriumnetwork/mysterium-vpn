// ignore_for_file: use_build_context_synchronously

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/components/dialogs/info_dialog.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

Future<void> shownDeleteAccountDialog(
  BuildContext context, {
  required AuthStore authStore,
  required VpnStore vpnStore,
  required AnalyticsStore analyticsStore,
}) async {
  analyticsStore.logEvent(AnalyticsEvent.deleteAccountPopup);
  showModalBottomSheet(
    clipBehavior: Clip.none,
    constraints: const BoxConstraints.tightFor(width: double.infinity),
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).palette.bgSecondary,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.kXl)),
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
  final VpnStore vpnStore;

  @override
  Widget build(BuildContext context) {
    final confirmationMessage = useState('');
    final spacing = Theme.of(context).spacing;
    return Observer(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.deleteAccountQuestion.tr(),
            style: Theme.of(context).textStyles.textLg.bold,
            textAlign: TextAlign.center,
          ).padding(bottom: spacing.lg),
          Text(
            LocaleKeys.cancelYourSubsMess.tr(),
            style: Theme.of(context).textStyles.textSm.semibold,
            textAlign: TextAlign.center,
          ).padding(bottom: spacing.md),
          Text(
            LocaleKeys.typeDelete.tr(),
            style: Theme.of(
              context,
            ).textStyles.textSm.bold.copyWith(color: Theme.of(context).palette.textTertiary),
            maxLines: 3,
          ).padding(bottom: spacing.md),
          TextField(
            onChanged: (val) => confirmationMessage.value = val,
            autocorrect: false,
            onTap: () {
              analyticsStore.logEvent(AnalyticsEvent.deleteAccountInput);
            },
            onTapOutside: (_) => FocusScope.of(context, createDependency: false).unfocus(),
          ).height(40).padding(bottom: 30),
          ButtonPrimary(
            onPressed:
                confirmationMessage.value == 'DELETE' &&
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
                        messages: [LocaleKeys.redirectToLoginPage.tr()],
                        onConfirm: () async {
                          await vpnStore.disconnectTunnel();
                          authStore.logout();
                        },
                      );
                    }
                  }
                : null,
            child: authStore.deleteAccountFeature.status == FutureStatus.pending
                ? const LoadingIndicator().paddingDirectional(end: 4)
                : Text(LocaleKeys.confirm.tr()),
          ),
        ],
      ).padding(horizontal: spacing.xl, vertical: spacing.xl2),
    );
  }
}
