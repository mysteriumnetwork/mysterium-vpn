class PackageNotFoundException implements Exception {
  PackageNotFoundException([this.message = 'Package not found']);
  final dynamic message;
}
