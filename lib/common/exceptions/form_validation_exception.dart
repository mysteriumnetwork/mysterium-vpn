class FormValidationException implements Exception {
  const FormValidationException([this.errors = const <String, Object>{}]);

  final Map<String, Object> errors;
}
