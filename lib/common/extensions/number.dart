extension NumberExtensions on double {
  String pricePerMonth({required int months}) => '\$${(this / months).toStringAsFixed(2)}';

  String price() => '\$$this';
}
