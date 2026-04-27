import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
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

class CancelSubscriptionSurveyDialog extends HookConsumerWidget {
  const CancelSubscriptionSurveyDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteConfigStore = ref.watch(remoteConfigStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);
    final reasons = useComputedValue(() {
      final keys = remoteConfigStore.cancelSubscriptionReasonKeys?.shuffled();
      keys?.remove(kCancelReasonOther);
      return {...?keys, kCancelReasonOther};
    });

    final form = _useForm();
    final submitFuture = useState<Future<void>?>(null);
    final submitState = useFuture(submitFuture.value);

    void handleCancel() {
      Navigator.of(context).pop();
    }

    void handleSubmit() {
      submitFuture.value = () async {
        if (!form.valid) {
          throw FormValidationException(form.errors);
        }

        final reasons = form.reasons.value!;
        var feedback = form.feedback.value?.trim();
        if (feedback?.isEmpty ?? false) {
          feedback = null;
        }
        await analyticsStore.logSubscriptionCancellationSurvey(
          reasons: reasons,
          feedback: feedback,
        );
      }();
    }

    useValueChanged<ConnectionState, void>(submitState.connectionState, (_, _) {
      if (submitState.connectionState == ConnectionState.done) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (submitState.hasError) {
            final error = submitState.error;
            if (error is FormValidationException) {
              showSnackbar(error.message);
            }
          }
          Navigator.of(context).pop(!submitState.hasError);
        });
      }
    });

    return BottomSheetDialog(
      title: LocaleKeys.cancelSurveyTitle.tr(),
      body: _Form(form: form, items: reasons),
      primaryButton: ButtonPrimary(
        onPressed: form.invalid || submitState.connectionState == ConnectionState.waiting
            ? null
            : handleSubmit,
        child: Text(LocaleKeys.submitBtn.tr()),
      ),
      secondaryButton: ButtonSecondary(
        onPressed: handleCancel,
        child: Text(LocaleKeys.cancelBtn.tr()),
      ),
    );
  }
}
