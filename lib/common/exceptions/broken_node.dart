class BrokenNodeException implements Exception {
  BrokenNodeException(this.location);
  final String location;

  @override
  String toString() => 'BrokenNodeException: $location';
}
