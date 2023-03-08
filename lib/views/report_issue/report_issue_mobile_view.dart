import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/base_layout.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/views/report_issue/report_issue_form.dart';
import 'package:styled_widget/styled_widget.dart';

class ReportIssueMobileView extends HookConsumerWidget {
  const ReportIssueMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => BaseLayout(
        headerTitle: LocaleKeys.reportAnIssue.tr(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: const ReportIssueForm(),
        ).paddingDirectional(all: 20),
      );
}
