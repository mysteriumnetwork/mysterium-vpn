// Values are ordered by priority of showing. First one is the most important.
enum BannerType {
  unauthenticated(isDismissable: false),
  subscription(isDismissable: false),
  appUpdateAvailable(shouldPersist: false),
  datacenter,
  highSpeedIPs(mainBanner: false),
  residentialIPs(mainBanner: false),
  tooManyConnections;

  const BannerType({this.isDismissable = true, this.mainBanner = true, this.shouldPersist = true});

  /// Whether the banner can be dismissed by the user.
  final bool isDismissable;
  final bool mainBanner;

  /// Whether the banner should shown again after app restart.
  final bool shouldPersist;

  static List<BannerType> get allBanners =>
      BannerType.values.toList().where((it) => it != BannerType.datacenter).toList();
  static List<BannerType> get mainBanners => allBanners.where((it) => it.mainBanner).toList();
  static List<BannerType> get secondaryBanners => allBanners.where((it) => !it.mainBanner).toList();
  static List<BannerType> get nonDismissableBanners =>
      allBanners.where((it) => !it.isDismissable).toList();
  static List<BannerType> get dismissableBanners =>
      allBanners.where((it) => it.isDismissable).toList();
  static List<BannerType> get mainAndDismissableBanners =>
      allBanners.where((it) => it.mainBanner && !it.isDismissable).toList();
  static List<BannerType> get secondaryAndDismissableBanners =>
      allBanners.where((it) => !it.mainBanner && !it.isDismissable).toList();
  static List<BannerType> get mainAndNonDismissableBanners =>
      allBanners.where((it) => it.mainBanner && it.isDismissable).toList();
  static List<BannerType> get secondaryAndNonDismissableBanners =>
      allBanners.where((it) => !it.mainBanner && it.isDismissable).toList();
}
