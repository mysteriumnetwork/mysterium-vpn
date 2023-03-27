import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/forms/forms.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:styled_widget/styled_widget.dart';

class ReportIssueForm extends HookWidget {
  const ReportIssueForm({super.key});

  @override
  Widget build(BuildContext context) {
    final reportIssueForm = useMemoized(reportIssue);

    return ReactiveForm(
      formGroup: reportIssueForm,
      child: Column(
        children: [
          EasyText(
            LocaleKeys.describeYourIssue.tr(),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ).padding(bottom: 10),
          ReactiveTextField(
            style: TextStyle(
              color: Theme.of(context).colorScheme.brightness == Brightness.light
                  ? Palette.black
                  : Palette.lightGrey,
            ),
            validationMessages: {
              ValidationMessage.required: (_) => LocaleKeys.fieldRequired.tr(),
            },
            formControlName: 'report_issue',
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              hintText: LocaleKeys.typeIssueHere.tr(),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Palette.lightBlack),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Palette.lightBlack),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            minLines: 5,
            maxLines: 5,
          ).padding(bottom: 20),
          ReactiveFormConsumer(
            builder: (context, form, child) => EasyButton(
              useSystemColor: false,
              text: LocaleKeys.sendToUs.tr(),
              onPressed: form.valid ? () {} : () => form.markAllAsTouched(),
            ),
          ),
        ],
      ).scrollable(),
    );
  }
}
