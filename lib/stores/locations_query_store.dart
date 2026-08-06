import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'locations_query_store.g.dart';

// ignore: library_private_types_in_public_api
class LocationsQueryStore = _LocationsQueryStore with _$LocationsQueryStore;

abstract class _LocationsQueryStore with Store, Disposeable {
  _LocationsQueryStore(this._prefs, this._analyticsStore, LocaleStore localeStore) {
    _localeReactionDisposer = reaction((_) => localeStore.currentLocale, (value) {
      if (_search.trim().isNotEmpty) {
        setSearch('', debounce: Duration.zero);
      }
    });
  }

  final SharedPreferenceService _prefs;
  final AnalyticsStore _analyticsStore;

  late final Debouncer _debouncer = Debouncer();
  late final ReactionDisposer _localeReactionDisposer;

  @readonly
  late String _search = '';

  @readonly
  late IPType _ipType = _prefs.getIPType() ?? IPType.residential;

  /// View-level flag: the Favorite tab is selected instead of an IP-type tab.
  /// Not persisted so the app always reopens on an IP-type list.
  @readonly
  bool _favoritesSelected = false;

  @computed
  LocationsTab get tab =>
      _favoritesSelected ? LocationsTab.favorite : LocationsTab.fromIPType(_ipType);

  @computed
  String get searchTrimmed => _search.trim();

  @action
  void setSearch(String value, {Duration debounce = const Duration(milliseconds: 500)}) {
    _debouncer.debounce(() async {
      _search = value;
      await _analyticsStore.setSearchEvent(_search);
    }, debounce);
  }

  /// The user picked a tab. Favorite has no [IPType]; the other tabs both
  /// select and persist theirs.
  @action
  Future<void> selectTab(LocationsTab tab) async {
    final ipType = tab.ipType;
    if (ipType == null) {
      _favoritesSelected = true;
      return;
    }
    _favoritesSelected = false;
    await syncIPType(ipType);
  }

  @action
  Future<void> setIPType(IPType value) {
    _favoritesSelected = false;
    return syncIPType(value);
  }

  /// Keeps the underlying IP type in sync (e.g. from connection changes)
  /// without stealing the selection away from the Favorite tab.
  @action
  Future<void> syncIPType(IPType value) async {
    _ipType = value;
    await _prefs.setIPType(value);
  }

  /// Drops a Favorite-tab selection when the tab goes away (logout, or the
  /// feature turning off), so every reader of [tab] agrees with the UI.
  @action
  void deselectFavoritesTab() {
    _favoritesSelected = false;
  }

  @override
  void dispose() {
    _localeReactionDisposer();
    _debouncer.dispose();
  }
}
