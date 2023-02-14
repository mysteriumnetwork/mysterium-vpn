import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:styled_widget/styled_widget.dart';

class SearchField extends HookWidget {
  const SearchField(this.store, {Key? key}) : super(key: key);

  final LocationsStore store;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: store.searchKeyword);
    return ReactionBuilder(
        builder: (context) {
          return reaction((_) => store.showAllLocations, (_) {
            controller.text = '';
          });
        },
        child: TextField(
          controller: controller,
          style: TextStyle(
            color: Theme.of(context).colorScheme.brightness == Brightness.light
                ? Palette.black
                : Palette.veryLightGrey,
          ),
          decoration: InputDecoration(
            filled: true,
            contentPadding: const EdgeInsets.only(left: 20),
            fillColor: Theme.of(context).colorScheme.surface,
            hintText: LocaleKeys.searchForLocations.tr(),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(20))),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(20))),
            suffixIcon: SvgIconButton(
              onPressed: () {
                if (store.showAllLocations) {
                  store.fetchAllLocations();
                  return;
                }
                store.fetchRecentLocations();
                store.fetchTopLocations();
              },
              asset: Assets.search,
            ).width(20),
          ),
          autocorrect: false,
          onChanged: (value) => store.setLocationKeyword(value),
          onSubmitted: (String value) {
            store.setLocationKeyword(value);
          },
        ).height(40));
  }
}
