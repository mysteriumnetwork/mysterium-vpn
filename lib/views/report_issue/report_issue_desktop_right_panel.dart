import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/forms/forms.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:styled_widget/styled_widget.dart';

class ReportIssueDesktopRightPanel extends HookConsumerWidget {
  const ReportIssueDesktopRightPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportIssueForm = useMemoized(reportIssue);

    return ReactiveForm(
      formGroup: reportIssueForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EasyText(
            LocaleKeys.reportAnIssue.tr(),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ).padding(bottom: 60),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EasyText(
                  LocaleKeys.describeYourIssue.tr(),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ).padding(bottom: 30),
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
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
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
                ).padding(bottom: 60),
                ReactiveFormConsumer(
                  builder: (context, form, child) => EasyButton(
                    useSystemColor: false,
                    text: LocaleKeys.sendToUs.tr(),
                    onPressed: form.valid ? () {} : () => form.markAllAsTouched(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .height(getMediaHeight(context))
        .padding(horizontal: 40, vertical: 40)
        .backgroundColor(Theme.of(context).colorScheme.onSurface)
        .scrollable();
  }
}
