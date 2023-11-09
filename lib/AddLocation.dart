import 'package:flutter/material.dart';
import 'Location.dart';
import 'LocationManager.dart'; 

void main() => runApp(MaterialApp(home: LocationController()));

// LocationController widget to interface with the LocationManager.
class LocationController extends StatefulWidget {
  @override
  _LocationControllerState createState() => _LocationControllerState();
}

class _LocationControllerState extends State<LocationController> {
  final LocationManager locationManager = LocationManager.instance;

  // Method to add a new location to the LocationManager.
  void addLocationToLocationManager(Location location) {
    // Precondition checks
    assert(locationManager != null && locationManager.isOpen(),
        'LocationManager must not be null and should be open.');

    // Adding a new location to the LocationManager
    setState(() {
      locationManager.addLocation(location);
    });

    // Postcondition check (in debug mode only)
    assert(locationManager.contains(location),
        'LocationManager should now contain the new location.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Controller'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: locationManager.getLocations().length,
              itemBuilder: (context, index) {
                var location = locationManager.getLocations()[index];
                return ListTile(
                  title: Text(location.name),
                  subtitle: Text(location.description),
                );
              },
            ),
          ),
          // Button to add a new location
          ElevatedButton(
            onPressed: () {
              // Here you would typically have a form or another method
              // to input the new location data instead of hardcoding it.
              Location newLocation = Location(name: 'New Park', description: 'A new public, urban park.');
              addLocationToLocationManager(newLocation);
            },
            child: Text('Add New Location'),
          ),
        ],
      ),
    );
  }
}
