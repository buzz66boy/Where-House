import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wherehouse/LocationController.dart';
import 'package:wherehouse/LocationListView.dart';
import 'package:wherehouse/database/Location.dart';
import 'package:wherehouse/database/LocationManager.dart';

void main() {
  testWidgets('Location View test', (WidgetTester tester) async {
    // Setup
    List<Location> locations = [
      Location(uid: 0, name: 'Tahiti', defaultLocation: -1),
      Location(uid: 2, name: 'Brazil', defaultLocation: -1)
    ];

    LocationManager locationManager = LocationManager();
    LocationController locationController =
        LocationController(locationManager: locationManager);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: LocationListView(
      locationList: locations,
      locationController: locationController,
    )));

    // Verify that the item's info is there.
    expect(find.text('Tahiti'), findsOneWidget);
    expect(find.text('ID: 0'), findsOneWidget);
    expect(find.text('Brazil'), findsOneWidget);
    expect(find.text('ID: 2'), findsOneWidget);
  });
}
