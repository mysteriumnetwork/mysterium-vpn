import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class SubscriptionComparisonTable extends StatelessWidget {
  const SubscriptionComparisonTable({required this.onShowPlansPressed, super.key});

  final VoidCallback onShowPlansPressed;

  @override
  Widget build(BuildContext context) {
    final config = GetIt.I<RemoteConfigStore>();
    final theme = Theme.of(context);

    return Observer(
      builder: (context) {
        final columns = config.planFeatures.map((it) => it.name).toList();

        final List<ComparisonFeature<String>> features;
        if (columns.isEmpty) {
          features = const [];
        } else {
          final first = config.planFeatures.first;
          final keys = first.detailedFeatures.keys;
          final count = columns.length;

          final list = <ComparisonFeature<String>>[];
          for (final key in keys) {
            final values = config.planFeatures
                .map((it) {
                  final value = it.detailedFeatures[key];
                  final comparisonValue = switch (value) {
                    final bool v => ComparisonAvailable(v) as ComparisonValue<dynamic>,
                    final num v => ComparisonText(v.toString()),
                    final String v => ComparisonText(v),
                    _ => null,
                  };
                  if (comparisonValue == null) {
                    return null;
                  }
                  return MapEntry(it.name, comparisonValue);
                })
                .nonNulls
                .toList();
            if (values.length != count) {
              continue;
            }
            list.add(
              ComparisonFeature(
                values: Map.fromEntries(values),
                label: key.tr(),
                description: _getDescriptionIfExists(key),
              ),
            );
          }
          features = list;
        }

        return ComparisonTable(
          headerIndexColumn: ButtonTertiary(
            size: ButtonSize.small,
            onPressed: onShowPlansPressed,
            decoration: const ButtonDecoration(padding: EdgeInsets.zero),
            leading: Icon(UntitledUI.arrow_up, size: 16, color: theme.palette.textPrimarySelected),
            child: Text(
              LocaleKeys.subscriptionAllPlansBackToPlans.tr(),
              style: theme.textStyles.textSm.regular.copyWith(
                color: theme.palette.textPrimarySelected,
              ),
            ),
          ),
          headerColumns: Map.fromEntries(columns.map((it) => MapEntry(it, it.tr()))),
          features: features,
        );
      },
    );
  }

  String? _getDescriptionIfExists(String key) {
    final id = '${key}Desc';
    final translated = id.tr();
    return translated != id && translated.isNotEmpty ? translated : null;
  }
}
