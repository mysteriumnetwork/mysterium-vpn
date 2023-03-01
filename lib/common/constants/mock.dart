import 'package:mysterium_vpn/models/location.dart';

const List<Location> recentLocationsMock = [
  Location(countryName: 'Austria', countryCode: 'at', duration: Duration(minutes: 10)),
  Location(countryName: 'Germany', countryCode: 'de', duration: Duration(minutes: 45)),
  Location(countryName: 'Italy', countryCode: 'it', duration: Duration(hours: 1, minutes: 30)),
  Location(
      countryName: 'France', countryCode: 'fr', duration: Duration(days: 1, hours: 1, minutes: 30)),
];

const List<Location> topLocationsMock = [
  Location(countryName: 'Austria', countryCode: 'at'),
  Location(countryName: 'Germany', countryCode: 'de'),
  Location(countryName: 'Italy', countryCode: 'it'),
  Location(countryName: 'France', countryCode: 'fr'),
  Location(countryName: 'Ukraine', countryCode: 'ua'),
  Location(countryName: 'Poland', countryCode: 'pl'),
  Location(countryName: 'Austria', countryCode: 'at'),
  Location(countryName: 'Andorra', countryCode: 'ad'),
  Location(countryName: 'Portugal', countryCode: 'pt'),
  Location(countryName: 'Qatar', countryCode: 'qa'),
  Location(countryName: 'Turkey', countryCode: 'tr'),
  Location(countryName: 'Lithuania', countryCode: 'lt'),
  Location(countryName: 'Macedonia', countryCode: 'mk'),
];

const List<Location> allLocationsMock = [
  Location(countryName: 'Austria', countryCode: 'at'),
  Location(countryName: 'Germany', countryCode: 'de'),
  Location(countryName: 'Italy', countryCode: 'it'),
  Location(countryName: 'France', countryCode: 'fr'),
  Location(countryName: 'Ukraine', countryCode: 'ua'),
  Location(countryName: 'Poland', countryCode: 'pl'),
  Location(countryName: 'Austria', countryCode: 'at'),
  Location(countryName: 'Andorra', countryCode: 'ad'),
  Location(countryName: 'Portugal', countryCode: 'pt'),
  Location(countryName: 'Qatar', countryCode: 'qa'),
  Location(countryName: 'Turkey', countryCode: 'tr'),
  Location(countryName: 'Lithuania', countryCode: 'lt'),
  Location(countryName: 'Macedonia', countryCode: 'mk'),
  Location(countryName: 'Malta', countryCode: 'mt'),
  Location(countryName: 'Moldova', countryCode: 'md'),
  Location(countryName: 'Monaco', countryCode: 'mc'),
  Location(countryName: 'Montenegro', countryCode: 'me'),
  Location(countryName: 'Peru', countryCode: 'pe'),
  Location(countryName: 'Philippines', countryCode: 'ph'),
];

final List<String> protocols = [
  'Protocol 1',
  'Protocol 2',
  'Protocol 3',
  'Protocol 4',
  'Protocol 5',
];
