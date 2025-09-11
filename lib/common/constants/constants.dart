import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

final List<Locale> kSupportedLocales = [
  kFallbackLocale,
  const Locale('fr', 'FR'),
  const Locale('pt', 'PT'),
  const Locale('tr', 'TR'),
  const Locale('de', 'DE'),
  const Locale('ar', 'AR'),
  const Locale('es', 'ES'),
  const Locale('id', 'ID'),
  const Locale('it', 'IT'),
  const Locale('ja', 'JP'),
  const Locale.fromSubtags(
    languageCode: 'zh',
    countryCode: 'CN',
  ),
];

const kFallbackLocale = Locale('en', 'US');

const String ksemiAnnualPlan = 'plan_6_months';
const String kMonthlyPlan = 'plan_monthly';
const String kAnnualPlan = 'plan_yearly';

const String kPopularPlan = ksemiAnnualPlan;
List<String> kProductIds = <String>[
  kMonthlyPlan,
  ksemiAnnualPlan,
  kAnnualPlan,
];

//scaffold messenger key used globally
final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

const privacyPolicyUrl = 'https://www.mysteriumvpn.com/privacy-policy-vpn';
const termsOfServiceUrl = 'https://www.mysteriumvpn.com/terms-conditions-vpn';
const windowsGithubDownloadLink =
    'https://github.com/mysteriumnetwork/mysterium-vpn-release/releases/latest/download/MysteriumVPN.msix';
const String bundleId = 'mysteriumvpn';
const String testBundleId = 'mysteriumtest';
const String iosBundleId = 'com.mysteriumvpn.tun';
const String iosTestBundleId = 'com.mysteriumvpn.test.tun';
const String win32ServiceName = 'MysteriumVPN_Wireguard';

// app ids
const appStoreId = '6446624307';
const appStoreIdMacOS = '6446624307';
const androidAppBundleId = 'com.mysteriumvpn.android';
const windowsProductId = '9NGWJCZSB5MK';
const windowsStandAloneProductId = 'te4cyv5h340wa';

//DNS Addresses
const malwareBlockerDomainAddress = '1.1.1.2';
const notSafeContentBlockerDomainAddress = '1.1.1.3';

// wold bounds
final kWorldBounds = LatLngBounds(
  const LatLng(-90, -180), // SW
  const LatLng(90, 180),
);
const kMapZoomLevels = <double>[3, 4];
// unlike kMapZoomLevels, these are the zoom levels used for the tiles - meaning that we support only tiles with these levels, and other zoom levels will use one of these as well
const kTileZoomLevels = <double>[3, 4];
const kCancelReasonOther = 'cancelOther';
