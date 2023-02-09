import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeDesktopView extends HookConsumerWidget {
  const HomeDesktopView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Text('Home Desktop View'),
    );
  }
}
