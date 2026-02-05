/// Compares semantic versions (e.g., "2.3.10" vs "2.3.8").
/// Returns: positive if version1 > version2, negative if version1 < version2, 0 if equal.
int compareSemanticVersions({
  required String currentAppVersion,
  required String otherVersion,
}) {
  final v1Parts = currentAppVersion.split('.');
  final v2Parts = otherVersion.split('.');

  for (var i = 0; i < (v1Parts.length > v2Parts.length ? v1Parts.length : v2Parts.length); i++) {
    final v1 =
        i < v1Parts.length ? int.tryParse(v1Parts[i].replaceAll(RegExp('[^0-9]'), '')) ?? 0 : 0;
    final v2 =
        i < v2Parts.length ? int.tryParse(v2Parts[i].replaceAll(RegExp('[^0-9]'), '')) ?? 0 : 0;

    if (v1 > v2) {
      return 1;
    }
    if (v1 < v2) {
      return -1;
    }
  }
  return 0;
}

/// Returns true if [currentAppVersion] is behind [comparisonVersion].
/// Useful for checking if an update is needed or if minimum version is not met.
bool isCurrentVersionBehind({
  required String currentAppVersion,
  required String comparisonVersion,
}) =>
    compareSemanticVersions(
      currentAppVersion: currentAppVersion,
      otherVersion: comparisonVersion,
    ) <
    0;
