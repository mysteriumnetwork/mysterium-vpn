import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReportIssueDesktopView extends HookConsumerWidget {
  const ReportIssueDesktopView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => const Center(
        child: Text('Report issue Desktop View'),
      );
}
