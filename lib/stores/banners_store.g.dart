// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banners_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BannersStore on _BannersStore, Store {
  Computed<List<BannerType>>? _$bannersComputed;

  @override
  List<BannerType> get banners => (_$bannersComputed ??=
          Computed<List<BannerType>>(() => super.banners, name: '_BannersStore.banners'))
      .value;
  Computed<BannerType?>? _$bannerComputed;

  @override
  BannerType? get banner =>
      (_$bannerComputed ??= Computed<BannerType?>(() => super.banner, name: '_BannersStore.banner'))
          .value;

  late final _$_shownBannersAtom = Atom(name: '_BannersStore._shownBanners', context: context);

  ObservableFuture<List<BannerType>> get shownBanners {
    _$_shownBannersAtom.reportRead();
    return super._shownBanners;
  }

  @override
  ObservableFuture<List<BannerType>> get _shownBanners => shownBanners;

  bool __shownBannersIsInitialized = false;

  @override
  set _shownBanners(ObservableFuture<List<BannerType>> value) {
    _$_shownBannersAtom.reportWrite(value, __shownBannersIsInitialized ? super._shownBanners : null,
        () {
      super._shownBanners = value;
      __shownBannersIsInitialized = true;
    });
  }

  late final _$setShownAsyncAction = AsyncAction('_BannersStore.setShown', context: context);

  @override
  Future<void> setShown(BannerType banner) {
    return _$setShownAsyncAction.run(() => super.setShown(banner));
  }

  @override
  String toString() {
    return '''
banners: ${banners},
banner: ${banner}
    ''';
  }
}
