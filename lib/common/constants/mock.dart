import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/recent_location.dart';

const List<RecentLocation> recentLocationsMock = [
  RecentLocation(name: 'Austria', duration: Duration(minutes: 10)),
  RecentLocation(name: 'Germany', duration: Duration(minutes: 45)),
  RecentLocation(name: 'Italy', duration: Duration(hours: 1, minutes: 30)),
  RecentLocation(name: 'Austria', duration: Duration(minutes: 10)),
  RecentLocation(name: 'Germany', duration: Duration(minutes: 45)),
  RecentLocation(name: 'Italy', duration: Duration(hours: 1, minutes: 30)),
];

const List<Location> topLocationsMock = [
  Location(name: 'Austria'),
  Location(name: 'Germany'),
  Location(name: 'Italy'),
  Location(name: 'France'),
  Location(name: 'Ukraine'),
  Location(name: 'Poland'),
  Location(name: 'Austria'),
  Location(name: 'Germany'),
  Location(name: 'Italy'),
  Location(name: 'France'),
  Location(name: 'Ukraine'),
  Location(name: 'Poland'),
];

const List<Location> allLocationsMock = [
  Location(name: 'Poland'),
  Location(name: 'Austria'),
  Location(name: 'Ukraine'),
  Location(name: 'Poland'),
  Location(name: 'Germany'),
  Location(name: 'Poland'),
  Location(name: 'Italy'),
  Location(name: 'France'),
  Location(name: 'Poland'),
  Location(name: 'Ukraine'),
  Location(name: 'Austria'),
  Location(name: 'Poland'),
  Location(name: 'Germany'),
  Location(name: 'Poland'),
];
