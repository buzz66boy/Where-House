import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wherehouse/LocationController.dart';
import 'package:wherehouse/LocationView.dart';
import 'package:wherehouse/database/Location.dart';
import 'package:wherehouse/database/LocationManager.dart';

void main() {
  testWidgets('Location View test', (WidgetTester tester) async {
    // Setup
    Location location = Location(uid: 0, name: 'Tahiti', defaultLocation: -1);

    LocationManager locationManager = LocationManager();
    LocationController locationController =
        LocationController(locationManager: locationManager);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: LocationView(
            location: location, locationController: locationController)));

    // Verify that the item's info is there.
    expect(find.text('Name: Tahiti'), findsOneWidget);
    expect(find.text('Unique ID: 0'), findsOneWidget);
    expect(find.text('Is Default? -1'), findsOneWidget);
  });
}
