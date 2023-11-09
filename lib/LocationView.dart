import Location.dart
import 'package:flutter/material.dart';

// Here's the Location class that I've created to represent the data for a location.
class Location {
  String name;
  String description;
  List<String> barcodes;
  List<String> locations;

  // The constructor initializes the Location with provided values.
  Location({
    required this.name,
    required this.description,
    required this.barcodes,
    required this.locations,
  });

  // These getters will help me retrieve the location's properties.
  String getName() => name;
  String getDescription() => description;
  List<String> getBarcodes() => barcodes;
  List<String> getLocations() => locations;
}

// The LocationView widget is a stateful widget because I want to update the UI dynamically.
class LocationView extends StatefulWidget {
  const LocationView({Key? key}) : super(key: key);

  @override
  _LocationViewState createState() => _LocationViewState();
}

// This is the state class that contains the state for my LocationView widget.
class _LocationViewState extends State<LocationView> {
  // These variables will hold the current location's data to be displayed.
  String name = '';
  String description = '';
  List<String> barcodes = [];
  List<String> locations = [];

  // The showLocation method updates the UI with the given Location's details.
  void showLocation(Location location) {
    // I'm using assert to ensure that the location is not null before proceeding.
    assert(location != null, 'The location must not be null.');

    // Calling setState tells Flutter to rebuild the UI with the new values.
    setState(() {
      name = location.getName();
      description = location.getDescription();
      barcodes = location.getBarcodes();
      locations = location.getLocations();
    });
  }

  @override
  Widget build(BuildContext context) {
    // I'm creating a dummy location instance for demonstration purposes.
    var dummyLocation = Location(
      name: 'Central Park',
      description: 'A large public, urban park in the city center.',
      barcodes: ['12345', '67890'],
      locations: ['Playground', 'Pond'],
    );

    // The Scaffold provides the structure for my app's UI.
    return Scaffold(
      appBar: AppBar(
        title: Text('Location View'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // This button, when pressed, will display the location's information.
          ElevatedButton(
            onPressed: () => showLocation(dummyLocation),
            child: Text('Show Location Info'),
          ),
          // Here, I'm displaying the location's data on the screen.
          Text('Name: $name'),
          Text('Description: $description'),
          Text('Barcodes: ${barcodes.join(', ')}'),
          Text('Locations: ${locations.join(', ')}'),
        ],
      ),
    );
  }
}

// The main function is the entry point for my Flutter app.
void main() {
  runApp(MaterialApp(home: LocationView()));
}
