import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/app_alert_dialog.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'cancel_subscription_survey_dialog/form.dart';
part 'cancel_subscription_survey_dialog/reasons_field.dart';

Future<bool?> showCancelSubscriptionSurveyDialog(BuildContext context) => showDialog<bool?>(
  context: context,
  builder: (context) => const CancelSubscriptionSurveyDialog(),
);

class CancelSubscriptionSurveyDialog extends HookConsumerWidget {
  const CancelSubscriptionSurveyDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
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
      Navigator.of(context, rootNavigator: true).pop();
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
          Navigator.of(context, rootNavigator: true).pop(!submitState.hasError);
        });
      }
    });

    return AppAlertDialog(
      titleText: LocaleKeys.cancelSurveyTitle.tr(),
      content: _Form(form: form, items: reasons),
      actions: [
        TextButton(
          onPressed: handleCancel,
          style: TextButton.styleFrom(foregroundColor: Palette.lightBlue),
          child: Text(
            LocaleKeys.cancelBtn.tr(),
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ),
        TextButton(
          onPressed: form.invalid || submitState.connectionState == ConnectionState.waiting
              ? null
              : handleSubmit,
          style: TextButton.styleFrom(
            foregroundColor: theme.palette.highlightColor,
            disabledForegroundColor: theme.palette.highlightColor.withValues(alpha: .5),
          ),
          child: Text(
            LocaleKeys.submitBtn.tr(),
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
