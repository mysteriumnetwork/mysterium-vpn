// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
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

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog({required this.authStore, required this.analyticsStore});

  final AuthStore authStore;
  final AnalyticsStore analyticsStore;

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  String _confirmationMessage = '';

  @override
  Widget build(BuildContext context) {
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
            onChanged: (val) => setState(() => _confirmationMessage = val),
            autocorrect: false,
            style: textStyles.textMd.regular.copyWith(color: palette.textPrimary),
            onTap: () {
              widget.analyticsStore.logEvent(AnalyticsEvent.deleteAccountInput);
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
          onPressed: _confirmationMessage == 'DELETE'
              ? () async {
                  widget.analyticsStore.logEvent(AnalyticsEvent.deleteAccountConfirm);
                  await widget.authStore.deleteAccount();
                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                }
              : null,
          loading: widget.authStore.deleteAccountFeature.status == FutureStatus.pending
              ? const ButtonLoading()
              : null,
          child: Text(LocaleKeys.allowBtn.tr()),
        ),
      ),
    );
  }
}
