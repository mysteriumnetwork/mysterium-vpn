import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationsSearch extends HookConsumerWidget {
  const LocationsSearch({this.enabled = true, super.key});

  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();

    void handleSearch(String? value) {
      final keyword = value?.trim() ?? '';
      final locationsQuery = ref.read(locationsQueryStorePOD);
      if (locationsQuery.searchTrimmed != keyword) {
        locationsQuery.setSearch(
          keyword,
          debounce: keyword.isEmpty ? Duration.zero : const Duration(milliseconds: 500),
        );
      }
    }

    final onChangedRef = useRef(handleSearch)..value = handleSearch;

    useEffect(() {
      void listener() {
        onChangedRef.value(controller.text);
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller, onChangedRef]);

    return SearchField(
      controller: controller,
      placeholder: LocaleKeys.searchForLocations.tr(),
      onSubmitted: handleSearch,
      enabled: enabled,
    );
  }
}
