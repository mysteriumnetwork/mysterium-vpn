import 'package:freezed_annotation/freezed_annotation.dart';

part 'terms_conditions.freezed.dart';

@freezed
abstract class TermsAndConditions with _$TermsAndConditions {
  const factory TermsAndConditions({required String content, required String version}) =
      _TermsAndConditions;
}
