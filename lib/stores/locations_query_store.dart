import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/debouncer.dart';
import 'package:mysterium_vpn/common/utils/disposeable.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'locations_query_store.g.dart';

// ignore: library_private_types_in_public_api
class LocationsQueryStore = _LocationsQueryStore with _$LocationsQueryStore;

abstract class _LocationsQueryStore with Store, Disposeable {
  _LocationsQueryStore(
    this._prefs,
    this._analyticsStore,
    LocaleStore localeStore,
  ) {
    _localeReactionDisposer = reaction(
      (_) => localeStore.currentLocale,
      (value) {
        if (_search.trim().isNotEmpty) {
          setSearch('', debounce: Duration.zero);
        }
      },
    );
  }

  final SharedPreferenceService _prefs;
  final AnalyticsStore _analyticsStore;

  late final Debouncer _debouncer = Debouncer();
  late final ReactionDisposer _localeReactionDisposer;

  @readonly
  late String _search = '';

  @readonly
  late IPType _ipType = _prefs.getIPType() ?? IPType.residential;

  @computed
  String get searchTrimmed => _search.trim();

  @action
  void setSearch(String value, {Duration debounce = const Duration(milliseconds: 500)}) {
    _debouncer.debounce(
      () async {
        _search = value;
        await _analyticsStore.setSearchEvent(_search);
      },
      debounce,
    );
  }

  @action
  Future<void> setIPType(IPType value) async {
    _ipType = value;
    await _prefs.setIPType(value);
    await _analyticsStore.logTabChange(value);
  }

  @override
  void dispose() {
    _localeReactionDisposer();
    _debouncer.dispose();
  }
}
