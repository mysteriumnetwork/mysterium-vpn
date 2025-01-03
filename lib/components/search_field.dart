import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:styled_widget/styled_widget.dart';

class SearchField extends HookWidget {
  const SearchField(this.store, this.analyticsStore, {super.key});

  final LocationsStore store;
  final AnalyticsStore analyticsStore;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: store.searchKeyword);
    useEffect(() {
      void listener() {}
      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller, store.setLocationKeyword]);
    return TextField(
      controller: controller,
      style: TextStyle(
        color: Theme.of(context).colorScheme.brightness == Brightness.light
            ? Palette.black
            : Palette.lightGrey,
      ),
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.only(left: 20),
        fillColor: Theme.of(context).colorScheme.surface,
        hintText: LocaleKeys.searchForLocations.tr(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        suffixIcon: _Button(
          controller: controller,
          onCleared: () => store.setLocationKeyword('', 0),
        ).width(20),
      ),
      autocorrect: false,
      onChanged: store.setLocationKeyword,
      onTapOutside: (_) => FocusScope.of(
        context,
        createDependency: false,
      ).unfocus(),
    ).height(40);
  }
}

class _Button extends HookWidget {
  const _Button({
    required this.controller,
    required this.onCleared,
  });

  final TextEditingController controller;
  final VoidCallback onCleared;

  @override
  Widget build(BuildContext context) {
    final canClear = useListenableSelector(controller, () => controller.text.isNotEmpty);
    if (!canClear) {
      return const SvgIcon(asset: Assets.search, width: 11);
    }

    void handleClear() {
      controller
        ..clear()
        ..text = '';
      FocusScope.of(context, createDependency: false).unfocus();
      onCleared();
    }

    return SvgIconButton(
      onPressed: handleClear,
      asset: Assets.clear,
    );
  }
}
