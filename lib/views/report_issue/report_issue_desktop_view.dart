import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/desktop_panels_layout.dart';
import 'package:mysterium_vpn/views/report_issue/report_issue_desktop_left_panel.dart';
import 'package:mysterium_vpn/views/report_issue/report_issue_desktop_right_panel.dart';

class ReportIssueDesktopView extends HookConsumerWidget {
  const ReportIssueDesktopView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => const DesktopPanelsLayout(
        leftPanel: ReportIssueDesktopLeftPanel(),
        rightPanel: ReportIssueDesktopRightPanel(),
      );
}
