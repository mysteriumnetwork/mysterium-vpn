import 'package:mysterium_vpn/common/enums/enums.dart';

/// Narrow analytics port for the data layer, so services and repositories can
/// report events without depending on `AnalyticsStore`.
typedef AnalyticsEventLogger =
    Future<void> Function(AnalyticsEvent event, {Map<String, dynamic>? parameters});
