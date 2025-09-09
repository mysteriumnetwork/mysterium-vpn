import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class LocationsSearch extends HookConsumerWidget {
  const LocationsSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final border = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(12),
    );

    void handleSearch(String? value) {
      final keyword = value?.trim() ?? '';
      final locationsStore = ref.read(locationsStorePOD);
      if (locationsStore.searchKeyword != keyword) {
        locationsStore.setLocationKeyword(
          keyword,
          keyword.isEmpty ? Duration.zero : const Duration(milliseconds: 500),
        );
      }
    }

    final onChangedRef = useRef(handleSearch)..value = handleSearch;

    useEffect(
      () {
        void listener() {
          onChangedRef.value(controller.text);
        }

        controller.addListener(listener);
        return () => controller.removeListener(listener);
      },
      [controller, onChangedRef],
    );

    return TextField(
      controller: controller,
      autocorrect: false,
      onTapOutside: (_) => FocusScope.of(
        context,
        createDependency: false,
      ).unfocus(),
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        constraints: const BoxConstraints(minHeight: 32),
        isDense: true,
        hintText: LocaleKeys.searchForLocations.tr(),
        border: border,
        focusedBorder: border,
        enabledBorder: border,
        suffixIcon: _Button(controller: controller),
        suffixIconConstraints: const BoxConstraints(maxHeight: 32),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    );
  }
}

class _Button extends HookWidget {
  const _Button({
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final canClear = useListenableSelector(controller, () => controller.text.isNotEmpty);

    void handleClear() {
      controller
        ..clear()
        ..text = '';
      FocusScope.of(context, createDependency: false).unfocus();
    }

    return IgnorePointer(
      ignoring: !canClear,
      child: IconButton(
        onPressed: handleClear,
        icon: (canClear ? Asset.icons.clear : Asset.icons.search).svg(height: 16),
      ),
    );
  }
}
