import Location.dart;
import 'package:flutter/material.dart';

class Location {
  String name;
  String description;
  List<String> barcodes;
  List<String> locations;

  Location({
    required this.name,
    required this.description,
    required this.barcodes,
    required this.locations,
  });

  String getName() => name;
  String getDescription() => description;
  List<String> getBarcodes() => barcodes;
  List<String> getLocations() => locations;
}

class LocationView extends StatefulWidget {
  const LocationView({Key? key}) : super(key: key);

  @override
  _LocationViewState createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  String name = '';
  String description = '';
  List<String> barcodes = [];
  List<String> locations = [];

  void showLocation(Location location) {
    assert(location != null, 'The location must not be null.');

    setState(() {
      name = location.getName();
      description = location.getDescription();
      barcodes = location.getBarcodes();
      locations = location.getLocations();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dummy location data, replace with your actual data retrieval logic
    var dummyLocation = Location(
      name: 'Central Park',
      description: 'A large public, urban park in the city center.',
      barcodes: ['12345', '67890'],
      locations: ['Playground', 'Pond'],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Location View'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElevatedButton(
            onPressed: () => showLocation(dummyLocation),
            child: Text('Show Location Info'),
          ),
          Text('Name: $name'),
          Text('Description: $description'),
          Text('Barcodes: ${barcodes.join(', ')}'),
          Text('Locations: ${locations.join(', ')}'),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: LocationView()));
}
