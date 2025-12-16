import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class SubscriptionComparisonTable extends HookConsumerWidget {
  const SubscriptionComparisonTable({
    required this.onShowPlansPressed,
    super.key,
  });

  final VoidCallback onShowPlansPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(remoteConfigStorePOD);
    final columns = useComputedValue<List<String>>(
      () => config.planFeatures.map((it) => it.name).toList(),
      [config],
    );
    final features = useComputedValue<List<ComparisonFeature<String>>>(
      () {
        final count = columns.length;
        if (count <= 0) {
          return const [];
        }

        final first = config.planFeatures.first;
        final keys = first.detailedFeatures.keys;

        final list = <ComparisonFeature<String>>[];

        for (final key in keys) {
          final values = config.planFeatures
              .map((it) {
                final value = it.detailedFeatures[key];
                final comparisonValue = switch (value) {
                  final bool value => ComparisonAvailable(value),
                  final num value => ComparisonText(value.toString()),
                  final String value => ComparisonText(value),
                  _ => null,
                };

                if (comparisonValue is! ComparisonValue) {
                  return null;
                }
                return MapEntry(it.name, comparisonValue);
              })
              .nonNulls
              .toList();
          if (values.length != count) {
            continue;
          }

          list.add(ComparisonFeature(values: Map.fromEntries(values), label: key.tr()));
        }

        return list;
      },
      [columns, config],
    );

    return ComparisonTable(
      headerIndexColumn: ButtonTertiary(
        size: ButtonSize.small,
        onPressed: onShowPlansPressed,
        leading: const Icon(UntitledUI.arrow_up),
        child: Text(LocaleKeys.subscriptionAllPlansBackToPlans.tr()),
      ),
      headerColumns: Map.fromEntries(columns.map((it) => MapEntry(it, it.tr()))),
      features: features,
    );
  }
}
