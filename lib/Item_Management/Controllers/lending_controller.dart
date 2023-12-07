import 'package:flutter/material.dart';
import 'package:wherehouse/Item_Management/Views/check_out_view.dart';
import 'package:wherehouse/Item_Management/Views/check_in_view.dart';
import 'package:wherehouse/database/Item.dart';
import 'package:wherehouse/Item_Management/Controllers/item_controller.dart';
import 'package:wherehouse/database/User.dart';
import 'package:wherehouse/database/UserManager.dart';
import 'package:wherehouse/home_screen.dart';

class LendingController {
  final ItemController itemController;
  final User user;
  late UserManager userManager;

  LendingController({required this.itemController, required this.user}) {
    userManager = UserManager();
  }

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
      int availableQuantity = locQuant[selectedLocation] ?? 0;

      // Ensure selectedQuantity does not exceed availableQuantity
      selectedQuantity = selectedQuantity > availableQuantity
          ? availableQuantity
          : selectedQuantity;

      int newQuantity = availableQuantity - selectedQuantity;

      // Update locQuant with the new quantity for the selectedLocation
      locQuant[selectedLocation] = newQuantity;

      // Update the item's location quantities
      itemController.updateItemLocationQuantities(
          itemUid: item.uid, uidQuantMap: locQuant);

      for (int i = 0; i < selectedQuantity; i++) {
        user.checkedOutItems.add(item.name);
      }
      userManager.saveUser(user);

      // Display an alert with the checkout message
      showCheckoutAlert(context, selectedQuantity);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp(user: user)),
      );
    } else {
      showAlert(context, 'Invalid Location', 'Location Does Not Exist');
    }
  }

  void checkInLogic(
      context, Item item, int selectedLocation, int selectedQuantity) async {
    Map<int, int> locQuant =
        await itemController.getItemLocationQuantities(item: item);
    int counter = 0;
    // Ensure the selectedLocation exists in the locQuant map

    if (user.checkedOutItems.contains(item.name)) {
      for (int i = 0; i < selectedQuantity; i++) {
        if (user.checkedOutItems.contains(item.name)) {
          user.checkedOutItems.remove(item.name);
          counter++;
        }
      }
      if (locQuant.containsKey(selectedLocation)) {
        int currentQuantity = locQuant[selectedLocation] ?? 0;
        int newQuantity = currentQuantity + counter;

        // Update locQuant with the new quantity for the selectedLocation
        locQuant[selectedLocation] = newQuantity;

        // Update the item's location quantities
        itemController.updateItemLocationQuantities(
            itemUid: item.uid, uidQuantMap: locQuant);
        userManager.saveUser(user);
        // Display an alert with the checkout message
        showCheckInAlert(context, counter);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp(user: user)),
        );
      }
    } else {
      showAlert(context, 'Check In Not Available',
          'You do not have any quantity checked out of this item.');
      Navigator.pop(context);
    }
  }

  void showAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

  void showCheckoutAlert(BuildContext context, int checkedOutQuantity) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text('Checkout Successful'),
          content:
              Text('${user.name} has checked out $checkedOutQuantity items.'),
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
