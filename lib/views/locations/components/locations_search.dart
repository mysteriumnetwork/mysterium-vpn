import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationsSearch extends HookConsumerWidget {
  const LocationsSearch({this.enabled = true, this.focusNode, super.key});

  final bool enabled;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final locationsQuery = ref.read(locationsQueryStorePOD);

    void handleSearch(String? value) {
      final keyword = value?.trim() ?? '';
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

    // Mirror store -> controller so external callers (e.g. the "Clear search"
    // button in the empty state) that reset the query also empty the field.
    // Preserve the cursor at the end so the user doesn't get yanked to
    // position 0 if the reaction fires while they're typing.
    useReaction<String>(() => locationsQuery.searchTrimmed, (storeSearch) {
      if (storeSearch != controller.text.trim()) {
        controller.value = TextEditingValue(
          text: storeSearch,
          selection: TextSelection.collapsed(offset: storeSearch.length),
        );
      }
    });

    return SearchField(
      controller: controller,
      focusNode: focusNode,
      placeholder: LocaleKeys.searchForLocations.tr(),
      onSubmitted: handleSearch,
      enabled: enabled,
    );
  }
}
