import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/features/locations/store/locations_query_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationsSearch extends StatefulWidget {
  const LocationsSearch({super.key});

  @override
  State<LocationsSearch> createState() => _LocationsSearchState();
}

class _LocationsSearchState extends State<LocationsSearch> {
  final _controller = TextEditingController();
  final _locationsQuery = getIt<LocationsQueryStore>();

  void _handleSearch(String? value) {
    final keyword = value?.trim() ?? '';
    if (_locationsQuery.searchTrimmed != keyword) {
      _locationsQuery.setSearch(
        keyword,
        debounce: keyword.isEmpty ? Duration.zero : const Duration(milliseconds: 500),
      );
    }
  }

  void _listener() {
    _handleSearch(_controller.text);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_listener);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_listener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SearchField(
    controller: _controller,
    placeholder: LocaleKeys.searchForLocations.tr(),
    onSubmitted: _handleSearch,
  );
}
