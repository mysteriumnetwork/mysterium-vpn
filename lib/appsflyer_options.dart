import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';

AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
  afDevKey: '9v6baAzA2PQVa7psnpF54F',
  appId: Platform.isIOS ? '6446624307' : '',
  disableAdvertisingIdentifier: true,
  disableCollectASA: true,
  showDebug: true,
);
