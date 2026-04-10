extension NumberExtensions on double {
  String pricePerMonth({
    required int months,
    required String currencySymbol,
    required String currencyCode,
  }) =>
      '${currencySymbol.isEmpty ? currencyCode : currencySymbol}${(this / months).toStringAsFixed(2)}';

  String pricePerYear({
    required int months,
    required String currencySymbol,
    required String currencyCode,
  }) =>
      '${currencySymbol.isEmpty ? currencyCode : currencySymbol}${(this / (months / 12)).toStringAsFixed(2)}';

  String price({required String currencySymbol, required String currencyCode}) =>
      '${currencySymbol.isEmpty ? currencyCode : currencySymbol}${toStringAsFixed(2)}';

  String toPriceString({required String currency}) =>
      price(currencySymbol: currency, currencyCode: currency);
}
