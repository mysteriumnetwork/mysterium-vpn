import 'package:easy_localization/easy_localization.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

class FormValidationException implements Exception {
  const FormValidationException([this.errors = const <String, Object>{}]);

  final Map<String, Object> errors;

  String get message => LocaleKeys.formValidationError.tr();
}
