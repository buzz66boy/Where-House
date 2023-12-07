import 'package:flutter/material.dart';
import 'package:wherehouse/Item_Management/Views/check_out_view.dart';
import 'package:wherehouse/Item_Management/Views/check_in_view.dart';
import 'package:wherehouse/database/Item.dart';
import 'package:wherehouse/Item_Management/Controllers/item_controller.dart';

class LendingController {
  final ItemController itemController;

  LendingController({required this.itemController});

  void checkOut(context, Item item) async {
    Map<int, int> locQuant =
        await itemController.getItemLocationQuantities(item: item);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CheckOutView(
                  item: item,
                  locationQuantities: locQuant,
                  lendingController: this,
                )));
  }

  void checkIn(context, Item item) async {
    Map<int, int> locQuant =
        await itemController.getItemLocationQuantities(item: item);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CheckInView(
                  item: item,
                  locationQuantities: locQuant,
                  lendingController: this,
                )));
  }

  void checkOutLogic(
      context, Item item, int selectedLocation, int selectedQuantity) async {
    Map<int, int> locQuant =
        await itemController.getItemLocationQuantities(item: item);

    // Ensure the selectedLocation exists in the locQuant map
    if (locQuant.containsKey(selectedLocation)) {
      int currentQuantity = locQuant[selectedLocation] ?? 0;
      int newQuantity = currentQuantity - selectedQuantity;

      // Ensure the new quantity is not negative
      newQuantity = newQuantity < 0 ? 0 : newQuantity;

      // Update locQuant with the new quantity for the selectedLocation
      locQuant[selectedLocation] = newQuantity;

      // Update the item's location quantities
      itemController.updateItemLocationQuantities(
          itemUid: item.uid, uidQuantMap: locQuant);

      // Display an alert with the checkout message
      showCheckoutAlert(context, selectedQuantity);
    }

    Navigator.pop(context);
  }

  void checkInLogic(
      context, Item item, int selectedLocation, int selectedQuantity) async {
    Map<int, int> locQuant =
        await itemController.getItemLocationQuantities(item: item);

    // Ensure the selectedLocation exists in the locQuant map
    if (locQuant.containsKey(selectedLocation)) {
      int currentQuantity = locQuant[selectedLocation] ?? 0;
      int newQuantity = currentQuantity + selectedQuantity;

      // Update locQuant with the new quantity for the selectedLocation
      locQuant[selectedLocation] = newQuantity;

      // Update the item's location quantities
      itemController.updateItemLocationQuantities(
          itemUid: item.uid, uidQuantMap: locQuant);

      // Display an alert with the checkout message
      showCheckInAlert(context, selectedQuantity);
    }

    Navigator.pop(context);
  }

  void showCheckoutAlert(BuildContext context, int checkedOutQuantity) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text('Checkout Successful'),
          content: Text('$checkedOutQuantity items checked out.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showCheckInAlert(BuildContext context, int checkedInQuantity) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text('Check-In Successful'),
          content: Text('$checkedInQuantity items returned.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
