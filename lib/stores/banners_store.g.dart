// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banners_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BannersStore on _BannersStore, Store {
  Computed<List<BannerType>?>? _$shownComputed;

  @override
  List<BannerType>? get shown => (_$shownComputed ??= Computed<List<BannerType>?>(
    () => super.shown,
    name: '_BannersStore.shown',
  )).value;
  Computed<bool>? _$shouldShowSubscriptionBannerComputed;

  @override
  bool get shouldShowSubscriptionBanner =>
      (_$shouldShowSubscriptionBannerComputed ??= Computed<bool>(
        () => super.shouldShowSubscriptionBanner,
        name: '_BannersStore.shouldShowSubscriptionBanner',
      )).value;
  Computed<List<BannerType>>? _$mainBannersComputed;

  @override
  List<BannerType> get mainBanners => (_$mainBannersComputed ??= Computed<List<BannerType>>(
    () => super.mainBanners,
    name: '_BannersStore.mainBanners',
  )).value;
  Computed<BannerType?>? _$mainBannerComputed;

  @override
  BannerType? get mainBanner => (_$mainBannerComputed ??= Computed<BannerType?>(
    () => super.mainBanner,
    name: '_BannersStore.mainBanner',
  )).value;
  Computed<List<BannerType>>? _$secondaryBannersComputed;

  @override
  List<BannerType> get secondaryBanners =>
      (_$secondaryBannersComputed ??= Computed<List<BannerType>>(
        () => super.secondaryBanners,
        name: '_BannersStore.secondaryBanners',
      )).value;
  Computed<bool>? _$shouldShowAppUpdateBannerComputed;

  @override
  bool get shouldShowAppUpdateBanner => (_$shouldShowAppUpdateBannerComputed ??= Computed<bool>(
    () => super.shouldShowAppUpdateBanner,
    name: '_BannersStore.shouldShowAppUpdateBanner',
  )).value;

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
    _$_shownBannersAtom.reportWrite(
      value,
      __shownBannersIsInitialized ? super._shownBanners : null,
      () {
        super._shownBanners = value;
        __shownBannersIsInitialized = true;
      },
    );
  }

  late final _$setShownAsyncAction = AsyncAction('_BannersStore.setShown', context: context);

  @override
  Future<void> setShown(BannerType banner) {
    return _$setShownAsyncAction.run(() => super.setShown(banner));
  }

  late final _$resetShownAsyncAction = AsyncAction('_BannersStore.resetShown', context: context);

  @override
  Future<void> resetShown() {
    return _$resetShownAsyncAction.run(() => super.resetShown());
  }

  @override
  String toString() {
    return '''
shown: ${shown},
shouldShowSubscriptionBanner: ${shouldShowSubscriptionBanner},
mainBanners: ${mainBanners},
mainBanner: ${mainBanner},
secondaryBanners: ${secondaryBanners},
shouldShowAppUpdateBanner: ${shouldShowAppUpdateBanner}
    ''';
  }
}
