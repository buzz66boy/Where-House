// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wherehouse/Item_Management/Controllers/item_controller.dart';

import 'package:wherehouse/Item_Management/Views/item_view.dart';
import 'package:wherehouse/LocationController.dart';
import 'package:wherehouse/database/Item.dart';
import 'package:wherehouse/database/ItemManager.dart';
import 'package:wherehouse/database/LocationManager.dart';

void main() {
  testWidgets('Item View test', (WidgetTester tester) async {
    // Setup

    Item item = Item(
        name: 'Test Item',
        description: 'Item used for testing',
        barcodes: ['1234', '4321'],
        locationUID: 0);

    ItemManager itemManager = ItemManager();
    LocationManager locationManager = LocationManager();
    LocationController locationController =
        LocationController(locationManager: locationManager);
    ItemController itemController = ItemController(
        itemManager: itemManager, locationController: locationController);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: ItemView(
            item: item,
            itemController: itemController,
            locationNames: const {0: "Tahiti", 2: "Brazil"},
            locationQuantities: const {0: 3, 2: 3})));

    // Verify that the item's info is there.
    expect(find.text('Item View: Test Item'), findsOneWidget);
    expect(find.text('Description: Item used for testing'), findsOneWidget);
    expect(find.text('Location: 0'), findsOneWidget);
    expect(find.text('Location: 2'), findsOneWidget);
    expect(find.text('Quantity: 3'), findsNWidgets(2));
  });
}
