import 'package:flutter/material.dart';
import 'package:wherehouse/Item_Management/Controllers/lending_controller.dart';
import 'package:wherehouse/database/Item.dart';

class CheckInView extends StatefulWidget {
  final Item item;
  final Map<int, int> locationQuantities;
  final LendingController lendingController;

  const CheckInView(
      {required this.item,
      required this.locationQuantities,
      required this.lendingController});

  @override
  _LendingViewState createState() => _LendingViewState();
}

class _LendingViewState extends State<CheckInView> {
  late int selectedLocation;
  late int selectedQuantity;

  @override
  void initState() {
    super.initState();
    selectedLocation = 0;
    selectedQuantity = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lending View: ${widget.item.name}'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Selected Item: ${widget.item.name}'),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: 'Location'),
                onChanged: (value) {
                  setState(() {
                    selectedLocation = int.tryParse(value) ?? 0;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    selectedQuantity = int.tryParse(value) ?? 0;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Call the lending controller to handle the check-out process
                  // LendingController.checkOut(
                  //     widget.item, selectedLocation, selectedQuantity);
                  // You may want to navigate back or perform other actions after check-out
                  widget.lendingController.checkInLogic(
                      context, widget.item, selectedLocation, selectedQuantity);
                },
                child: const Text('Return'),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  // Call the lending controller to handle the check-out process
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
