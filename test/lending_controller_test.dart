import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wherehouse/Item_Management/Controllers/lending_controller.dart';
import 'package:wherehouse/Item_Management/Controllers/item_controller.dart';
import 'package:wherehouse/database/Item.dart';

void main() {
  testWidgets('Check Out Logic - Successful Checkout', (WidgetTester tester) async {
    // Arrange
    ItemController itemController = ItemController();
    LendingController lendingController = LendingController(itemController: itemController);
    Item testItem = Item(name: 'Chalk', description: "White", barcodes: ['123', '456'], locationUID: 89);

    // Act
    await testItem.setItem(); // Ensure the item is in the database
    await lendingController.checkOutLogic(null, testItem, 1, 3); // Assuming initial quantity is 5

    // Assert
    Map<int, int> updatedQuantities = await itemController.getItemLocationQuantities(item: testItem);
    expect(updatedQuantities[1], 2); // Assuming the initial quantity was 5 and you checked out 3
  });

  testWidgets('Check In Logic - Successful Check-In', (WidgetTester tester) async {
    // Arrange
    ItemController itemController = ItemController();
    LendingController lendingController = LendingController(itemController: itemController);
    Item testItem = Item(name: 'Chalk', description: "White", barcodes: ['123', '456'], locationUID: 89);

    // Act
    await testItem.setItem(); // Ensure the item is in the database
    await lendingController.checkInLogic(null, testItem, 1, 3);

    // Assert
    Map<int, int> updatedQuantities = await itemController.getItemLocationQuantities(item: testItem);
    expect(updatedQuantities[1], 3); // Assuming the initial quantity was 0 and you checked in 3
  });

  testWidgets('Show Checkout Alert', (WidgetTester tester) async {
    // Arrange
    Widget widget = MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          return ElevatedButton(
            onPressed: () {
              LendingController lendingController = LendingController(itemController: ItemController());
              lendingController.showCheckoutAlert(context, 2);
            },
            child: Text('Show Checkout Alert'),
          );
        },
      ),
    );

    // Act & Assert
    await tester.pumpWidget(widget);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Checkout Successful'), findsOneWidget);
    expect(find.text('2 items checked out.'), findsOneWidget);
  });

  testWidgets('Show Check-In Alert', (WidgetTester tester) async {
    // Arrange
    Widget widget = MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          return ElevatedButton(
            onPressed: () {
              LendingController lendingController = LendingController(itemController: ItemController());
              lendingController.showCheckInAlert(context, 3);
            },
            child: Text('Show Check-In Alert'),
          );
        },
      ),
    );

    // Act & Assert
    await tester.pumpWidget(widget);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Check-In Successful'), findsOneWidget);
    expect(find.text('3 items returned.'), findsOneWidget);
  });
}
