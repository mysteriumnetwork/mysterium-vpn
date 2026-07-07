// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
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
      title: S.current.accountSuccessfullyDeleted,
      supportingText: S.current.redirectToLoginPage,
      dismissible: false,
      showCancel: false,
      confirmText: S.current.goToLoginBtn,
      confirmVariant: ButtonVariant.secondary,
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
    final spacing = Theme.of(context).spacing;
    return Observer(
      builder: (context) => AlertModal(
        type: AlertModalType.error,
        title: S.current.deleteAccountQuestion,
        supportingText: '${S.current.cancelYourSubsMess} ${S.current.typeDelete('DELETE')}',
        input: SizedBox(
          child: TextField(
            onChanged: (val) => confirmationMessage.value = val,
            autocorrect: false,
            style: textStyles.textMd.regular.copyWith(color: palette.gray.shade800),
            onTap: () {
              analyticsStore.logEvent(AnalyticsEvent.deleteAccountInput);
            },
            onTapOutside: (_) => FocusScope.of(context, createDependency: false).unfocus(),
            decoration: InputDecoration(
              hintText: S.current.typeDelete('DELETE'),
              hintStyle: textStyles.textMd.regular.copyWith(color: palette.gray.shade500),
              filled: true,
              fillColor: Palette.white,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: spacing.lg, vertical: spacing.md),
              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.kXs)),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.kXs),
                borderSide: BorderSide(color: palette.gray.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.kXs),
                borderSide: BorderSide(color: palette.borderBrand),
              ),
            ),
          ),
        ),
        primaryButton: ButtonSecondary(
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
          child: Text(S.current.allowBtn),
        ),
      ),
    );
  }
}
