import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:styled_widget/styled_widget.dart';

class SearchField extends StatelessWidget {
  const SearchField(this.store, {Key? key}) : super(key: key);

  final LocationsStore store;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.only(left: 20),
        fillColor: Theme.of(context).colorScheme.surface,
        hintText: LocaleKeys.search_for_locations.tr(),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(20)) //<-- SEE HERE
            ),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(20)) //<-- SEE HERE
            ),
        suffixIcon: const SvgIcon(
          asset: Assets.search,
        ).width(20),
      ),
      autocorrect: false,
      onChanged: (value) => store.setLocationKeyword(value),
      onSubmitted: (String user) {
        store.setLocationKeyword(user);
      },
    ).height(40);
  }
}
