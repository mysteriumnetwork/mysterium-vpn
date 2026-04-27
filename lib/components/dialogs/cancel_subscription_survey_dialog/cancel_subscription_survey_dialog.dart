import 'dart:async';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/constants/constants.dart';
import 'package:mysterium_vpn/core/exceptions/exceptions.dart';
import 'package:mysterium_vpn/core/extensions/extensions.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'form.dart';
part 'reasons_field.dart';

Future<bool?> showCancelSubscriptionSurveyDialog(BuildContext context) async =>
    showBottomSheetDialog<bool?>(
      context,
      mobileConstraints: BoxConstraints(maxHeight: getMediaHeight(context) * 0.95),
      desktopConstraints: const BoxConstraints(maxWidth: 637, maxHeight: 700),
      builder: (context) => const CancelSubscriptionSurveyDialog(),
    );

class CancelSubscriptionSurveyDialog extends StatefulWidget {
  const CancelSubscriptionSurveyDialog({super.key});

  @override
  State<CancelSubscriptionSurveyDialog> createState() => _CancelSubscriptionSurveyDialogState();
}

class _CancelSubscriptionSurveyDialogState extends State<CancelSubscriptionSurveyDialog> {
  final _remoteConfigStore = getIt<RemoteConfigStore>();
  final _analyticsStore = getIt<AnalyticsStore>();
  late final _FormGroup _form;
  late final StreamSubscription<dynamic> _formSub;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _form = _FormGroup._();
    _formSub = _form.valueChanges.listen((_) => setState(() {}));
  }

  @override
  void dispose() {
    _formSub.cancel();
    _form.dispose();
    super.dispose();
  }

  void _handleCancel() => Navigator.of(context).pop();

  Future<void> _handleSubmit() async {
    if (!_form.valid) {
      showSnackbar(FormValidationException(_form.errors).message);
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final reasons = _form.reasons.value!;
      var feedback = _form.feedback.value?.trim();
      if (feedback?.isEmpty ?? false) {
        feedback = null;
      }
      await _analyticsStore.logSubscriptionCancellationSurvey(reasons: reasons, feedback: feedback);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (_) {
      if (mounted) {
        Navigator.of(context).pop(false);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Observer(
    builder: (context) {
      final keys = _remoteConfigStore.cancelSubscriptionReasonKeys?.shuffled();
      keys?.remove(kCancelReasonOther);
      final reasons = {...?keys, kCancelReasonOther};

      return BottomSheetDialog(
        title: LocaleKeys.cancelSurveyTitle.tr(),
        body: _Form(form: _form, items: reasons),
        primaryButton: ButtonPrimary(
          onPressed: _form.invalid || _isSubmitting ? null : _handleSubmit,
          child: Text(LocaleKeys.submitBtn.tr()),
        ),
        secondaryButton: ButtonSecondary(
          onPressed: _handleCancel,
          child: Text(LocaleKeys.cancelBtn.tr()),
        ),
      );
    },
  );
}
