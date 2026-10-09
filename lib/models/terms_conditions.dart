import 'package:freezed_annotation/freezed_annotation.dart';

part 'terms_conditions.freezed.dart';

@freezed
abstract class TermsAndConditions with _$TermsAndConditions {
  const factory TermsAndConditions({required String content, required String version}) =
      _TermsAndConditions;
}

/// Consent state as the backend sees it, shared with Dashboard.
@freezed
abstract class TermsConsent with _$TermsConsent {
  const factory TermsConsent({String? acceptedVersion, String? latestVersion}) = _TermsConsent;

  const TermsConsent._();

  /// True when the backend advertises a version the user has not accepted.
  bool get requiresAcceptance =>
      (latestVersion?.isNotEmpty ?? false) && latestVersion != acceptedVersion;
}
