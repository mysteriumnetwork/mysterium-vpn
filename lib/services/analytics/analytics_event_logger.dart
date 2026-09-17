import 'package:mysterium_vpn/common/enums/enums.dart';

/// Narrow analytics port for the data layer, so services and repositories can
/// report events without depending on `AnalyticsStore`.
typedef AnalyticsEventLogger =
    Future<void> Function(AnalyticsEvent event, {Map<String, dynamic>? parameters});

/// Narrow port for reporting a handled failure, so the data layer can report
/// one without depending on `AnalyticsStore`.
typedef NonFatalLogger =
    Future<void> Function({required Object err, StackTrace? stack, String? reason});
