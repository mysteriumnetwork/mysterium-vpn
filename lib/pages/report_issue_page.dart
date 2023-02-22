import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/views/report_issue/report_issue_desktop_view.dart';
import 'package:mysterium_vpn/views/report_issue/report_issue_mobile_view.dart';

class ReportIssuePage extends StatelessWidget {
  const ReportIssuePage({super.key});

  @override
  Widget build(BuildContext context) => ColoredScaffold(
        body: ScreenTypeLayoutBuilder(
          mobile: (BuildContext context) => const ReportIssueMobileView(),
          tablet: (BuildContext context) => const ReportIssueDesktopView(),
          desktop: (BuildContext context) => const ReportIssueDesktopView(),
        ),
      );
}
