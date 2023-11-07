import Location.dart
import 'package:flutter/material.dart';


class LocationListView extends StatefulWidget {
  final List<Location> locations;

  LocationListView({required this.locations});

  @override
  _LocationListViewState createState() => _LocationListViewState();
}

class _LocationListViewState extends State<LocationListView> {
  String locationNameToFind = "LocationName"; // The name of the location to find
  Location? foundLocation;

  @override
  void initState() {
    super.initState();
    foundLocation = findLocationByName(widget.locations, locationNameToFind);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location List'),
      ),
      body: ListView.builder(
        itemCount: widget.locations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.locations[index].getName()),
            // You can customize the ListTile appearance as needed.
          );
        },
      ),
    );
  }

  Location? findLocationByName(List<Location> locations, String nameToFind) {
    for (var location in locations) {
      if (location.getName() == nameToFind) {
        return location;
      }
    }
    return null;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<Location> locations = [
    Location(name: 'Location 1'),
    Location(name: 'Location 2'),
    Location(name: 'Location 3'),
    // Add more locations here
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LocationListView(locations: locations),
    );
  }
}
