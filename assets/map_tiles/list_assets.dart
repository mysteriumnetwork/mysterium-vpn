import 'dart:io';

void main() async {
  // Get the current directory
  final currentDir = Directory(
    [Directory.current.path, 'assets', 'map_tiles'].join(Platform.pathSeparator),
  );

  // Recursively list all folders in the current directory
  final folders = <String>[];
  await for (final entity in currentDir.list(recursive: true, followLinks: false)) {
    if (entity is Directory) {
      // Add the folder path relative to the current directory
      final relativePath = entity.path.replaceFirst('${currentDir.path}/', '');
      folders.add('    - assets/map_tiles/$relativePath/');
    }
  }

  // Path to the pubspec.yaml file (2 levels above the current directory)
  final pubspecPath = '${Directory.current.path}/pubspec.yaml';
  final pubspecFile = File(pubspecPath);

  if (!pubspecFile.existsSync()) {
    print('Error: pubspec.yaml not found at $pubspecPath');
    return;
  }

  // Read the pubspec.yaml file
  final pubspecContent = await pubspecFile.readAsString();

  // Define the comment markers
  const startMarker = '\n    # BEGIN auto-generated assets';
  const endMarker = '    # END auto-generated assets';

  // Check if the markers already exist
  final startIndex = pubspecContent.indexOf(startMarker);
  final endIndex = pubspecContent.indexOf(endMarker);

  String updatedPubspecContent;

  if (startIndex != -1 && endIndex != -1) {
    // Replace the existing auto-generated section
    final before = pubspecContent.substring(0, startIndex);
    final after = pubspecContent.substring(endIndex + endMarker.length);
    final newSection = '$startMarker\n${folders.join('\n')}\n$endMarker';
    updatedPubspecContent = '$before$newSection$after';
  } else {
    // Append the auto-generated section at the end of the assets section
    final assetsSectionStart = pubspecContent.indexOf('assets:');
    if (assetsSectionStart == -1) {
      print('Error: No "assets:" section found in pubspec.yaml');
      return;
    }

    final beforeAssets = pubspecContent.substring(0, assetsSectionStart + 'assets:'.length);
    final afterAssets = pubspecContent.substring(assetsSectionStart + 'assets:'.length);
    final newSection = '$startMarker\n${folders.join('\n')}\n$endMarker';
    updatedPubspecContent = '$beforeAssets$afterAssets$newSection';
  }

  // Write the updated content back to pubspec.yaml
  await pubspecFile.writeAsString(updatedPubspecContent);

  print('Folders successfully added to the assets section of pubspec.yaml');
}
