extension NumberExtensions on double {
  String pricePerMonth({
    required int months,
    required String currencySymbol,
    required String currencyCode,
  }) =>
      '${currencySymbol.isEmpty ? currencyCode : currencySymbol}${(this / months).toStringAsFixed(2)}';

  String price({
    required String currencySymbol,
    required String currencyCode,
  }) =>
      '${currencySymbol.isEmpty ? currencyCode : currencySymbol}${toStringAsFixed(2)}';
}
