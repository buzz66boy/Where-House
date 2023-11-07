
import 'package:flutter/material.dart';

class SetLocationInformationScreen extends StatefulWidget {
  final LocationController locationController;
  final Location targetLocation;

  SetLocationInformationScreen({
    required this.locationController,
    required this.targetLocation,
  });

  @override
  _SetLocationInformationScreenState createState() =>
      _SetLocationInformationScreenState();
}

class _SetLocationInformationScreenState
    extends State<SetLocationInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController barcodesController = TextEditingController();
  final TextEditingController locationQuantityController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Location Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Location Name'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: barcodesController,
              decoration: InputDecoration(labelText: 'Barcodes (comma-separated)'),
            ),
            TextFormField(
              controller: locationQuantityController,
              decoration: InputDecoration(
                labelText: 'Location Quantity Map (JSON format)',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Parse barcodes as a list
                List<String> newBarcodes = barcodesController.text.split(',');

                // Parse location quantity map as a JSON string and decode it
                Map<String, dynamic> locationQuantityMap =
                    json.decode(locationQuantityController.text);
                Map<int, int> newLocationQuantityMap = {};
                locationQuantityMap.forEach((key, value) {
                  newLocationQuantityMap[int.parse(key)] = value;
                });

                // Call the setLocationInformation method
                widget.locationController.setLocationInformation(
                  widget.targetLocation,
                  nameController.text,
                  descriptionController.text,
                  newBarcodes,
                  newLocationQuantityMap,
                );

                // Navigate back to the previous screen
                Navigator.pop(context);
              },
              child: Text('Save Location Information'),
            ),
          ],
        ),
      ),
    );
  }
}
