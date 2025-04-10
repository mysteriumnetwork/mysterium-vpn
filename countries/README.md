# Countries Data Processing

This directory contains resources and scripts to process country data, specifically to extract latitude and longitude coordinates for each country based on their country codes.

## Purpose

The goal is to simplify and consolidate the data from the [countries-data-json repository](https://github.com/countries/countries-data-json). The JSON files in the repository contain a lot of unrelated data, but we are only interested in the following:

- **Country Codes**: ISO 3166-1 alpha-2 codes (e.g., `US`, `IN`, `FR`).
- **Coordinates**: Latitude and longitude (`latlng`) of each country.

The processed data will be stored in a single JSON file where:

- **Keys**: Country codes.
- **Values**: Latitude and longitude as an array (e.g., `[lat, lng]`).

This consolidated JSON file will be used in the application for quick lookups.

## Directory Structure

- `source/`: Contains the raw JSON files downloaded from the `countries-data-json` repository.
- `scripts/`: Contains the Dart script to process the JSON files.

## Steps to Process the Data

1. **Download JSON Files**: Clone or download the JSON files from the [countries-data-json repository](https://github.com/countries/countries-data-json) into the `source/` directory.

2. **Run the Dart Script**:
   - A Dart script will iterate through all the JSON files in the `countries/source/` directory.
   - It will extract the `latlng` data for each country and map it to the corresponding country code.
   - The output will be a single JSON file stored in the `assets/data/` directory.

3. **Use the Processed Data**:
   - The generated JSON file can be used in the application to fetch coordinates based on country codes.

## Example Output

The final JSON file will look like this:

```json
{
  "US": [37.0902, -95.7129],
  "IN": [20.5937, 78.9629],
  "FR": [46.6034, 1.8883]
}
```

## Future Plans

Eventually, this data processing will be moved to the API level to avoid maintaining static files in the application. For now, this approach serves as a temporary solution.

## How to Run the Script

1. Ensure you have Dart installed on your system.
2. Navigate to the `scripts/` directory.
3. Run the script using the following command:
   ```bash
   dart process_countries.dart
   ```
4. The processed JSON file will be generated in the `output/` directory.

## Notes

- Ensure the `source/` directory contains only valid JSON files from the `countries-data-json` repository.
- The script will skip files that do not contain the required `latlng` data.

## License

This project uses data from the [countries-data-json repository](https://github.com/countries/countries-data-json), which may have its own licensing terms. Please review their repository for more details.