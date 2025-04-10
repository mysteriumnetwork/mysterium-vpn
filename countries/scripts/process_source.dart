import 'dart:convert';
import 'dart:io';

void main() async {
  const sourceDir = 'countries/source';
  const outputFile = 'assets/data/countries_latlng.json';

  final directory = Directory(sourceDir);
  final outputDirectory = Directory('assets/data');

  // Ensure the output directory exists
  if (!outputDirectory.existsSync()) {
    outputDirectory.createSync(recursive: true);
  }

  final countryLatLng = <String, Map<String, double>>{};

  // Iterate through all JSON files in the source directory
  await for (final entity in directory.list()) {
    if (entity is File && entity.path.endsWith('.json')) {
      final content = await entity.readAsString();
      final jsonData = jsonDecode(content);

      if (jsonData is! Map<String, dynamic>) {
        throw Exception('Invalid JSON format in ${entity.path}');
      }

      for (final entry in jsonData.entries) {
        final countryCode = entry.key;
        final data = entry.value;
        if (data is! Map<String, dynamic>) {
          continue;
        }

        // Check if 'geo' key exists and contains 'latitude' and 'longitude'
        final geo = data['geo'];
        if (geo is! Map<String, dynamic>) {
          continue;
        }

        final latitude = geo['latitude'];
        final longitude = geo['longitude'];
        if (latitude is! double || longitude is! double) {
          continue;
        }

        // Add to the map
        countryLatLng[countryCode] = {
          'latitude': latitude,
          'longitude': longitude,
        };
      }
    }
  }

  // Write the consolidated JSON to the output file
  final outputFileHandle = File(outputFile);
  await outputFileHandle.writeAsString(jsonEncode(countryLatLng));
}
