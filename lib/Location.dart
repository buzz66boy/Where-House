import 'package:flutter/material.dart';
import 'LocationView.dart'; // I'm importing the LocationView widget here.
import 'LocationListView.dart'; // Here's where I import the LocationListView widget.
import 'AddLocation.dart'; // This is for importing the AddLocation widget.
import 'SetLocation.dart'; // And this is for importing the SetLocation widget.

// Below is my Location class with properties for name, description, etc.
class Location {
  String _name;
  String _description;
  List<String> _barcodes;
  List<String> _locations;

  Location({
    required String name,
    required String description,
    required List<String> barcodes,
    required List<String> locations,
  }) {
    _name = name;
    _description = description;
    _barcodes = barcodes;
    _locations = locations;
  }

  String getName() => _name; // Here I can get the name of the location.
  String getDescription() => _description; // This lets me get the description.
  List<String> getBarcodes() => _barcodes; // Here I can retrieve the list of barcodes.
  List<String> getLocations() => _locations; // And this gets me the list of locations.
}

// This is the main view for my Location app.
class LocationMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Main'), // I'm setting the title of my app bar here.
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Below, I've added a button that navigates to the LocationView.
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocationView()),
                );
              },
              child: Text('Location View'),
            ),
            // This button is for navigating to the LocationListView.
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocationListView()),
                );
              },
              child: Text('Location List View'),
            ),
            // I use this button when I want to add a new location.
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddLocation()),
                );
              },
              child: Text('Add Location'),
            ),
            // And this button is for setting information about a location.
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SetLocation()),
                );
              },
              child: Text('Set Location Info'),
            ),
          ],
        ),
      ),
    );
  }
}

// I'm starting my app here with the LocationMainView widget.
void main() {
  runApp(MaterialApp(home: LocationMainView()));
}
