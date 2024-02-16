class BrokenNodeException implements Exception {
  BrokenNodeException(this.location);
  final String location;
  final int code = 1112;

  @override
  String toString() => 'BrokenNodeException: $location';
}
