// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart' hide ScreenType;
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> shownDeleteAccountDialog(
  BuildContext context, {
  required AuthStore authStore,
  required VpnStore vpnStore,
  required AnalyticsStore analyticsStore,
}) async {
  analyticsStore.logEvent(AnalyticsEvent.deleteAccountPopup);
  final deleted = await showDialog<bool>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      constraints: const BoxConstraints(maxWidth: 350),
      child: _DeleteAccountDialog(authStore: authStore, analyticsStore: analyticsStore),
    ),
  );
  if ((deleted ?? false) && context.mounted) {
    shownConfirmationDialog(
      context,
      type: AlertModalType.success,
      title: LocaleKeys.accountSuccessfullyDeleted.tr(),
      supportingText: LocaleKeys.redirectToLoginPage.tr(),
      dismissible: false,
      showCancel: false,
      confirmText: LocaleKeys.continueBtn.tr(),
      onConfirm: () async {
        await vpnStore.disconnectTunnel();
        authStore.logout();
      },
    );
  }
}

class _DeleteAccountDialog extends HookWidget {
  const _DeleteAccountDialog({required this.authStore, required this.analyticsStore});

  final AuthStore authStore;
  final AnalyticsStore analyticsStore;

  @override
  Widget build(BuildContext context) {
    final confirmationMessage = useState('');
    final palette = Theme.of(context).palette;
    final textStyles = Theme.of(context).textStyles;
    return Observer(
      builder: (context) => AlertModal(
        type: AlertModalType.error,
        title: LocaleKeys.deleteAccountQuestion.tr(),
        supportingText: '${LocaleKeys.cancelYourSubsMess.tr()} ${LocaleKeys.typeDelete.tr()}',
        input: SizedBox(
          height: 40,
          child: TextField(
            onChanged: (val) => confirmationMessage.value = val,
            autocorrect: false,
            style: textStyles.textMd.regular.copyWith(color: palette.textPrimary),
            onTap: () {
              analyticsStore.logEvent(AnalyticsEvent.deleteAccountInput);
            },
            onTapOutside: (_) => FocusScope.of(context, createDependency: false).unfocus(),
            decoration: InputDecoration(
              hintText: LocaleKeys.typeDelete.tr(),
              hintStyle: textStyles.textMd.regular.copyWith(color: palette.textTertiary),
              filled: true,
              fillColor: palette.bgPrimary,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.kXs)),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.kXs),
                borderSide: BorderSide(color: palette.borderPrimary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.kXs),
                borderSide: BorderSide(color: palette.borderBrand),
              ),
            ),
          ),
        ),
        primaryButton: ButtonPrimary(
          onPressed: confirmationMessage.value == 'DELETE'
              ? () async {
                  analyticsStore.logEvent(AnalyticsEvent.deleteAccountConfirm);
                  await authStore.deleteAccount();
                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                }
              : null,
          loading: authStore.deleteAccountFeature.status == FutureStatus.pending
              ? const ButtonLoading()
              : null,
          child: Text(LocaleKeys.allowBtn.tr()),
        ),
      ),
    );
  }
}
