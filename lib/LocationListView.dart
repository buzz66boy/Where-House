import 'package:wherehouse/LocationController.dart';
import 'package:wherehouse/database/Location.dart';
import 'LocationView.dart';
import 'package:flutter/material.dart';

// I'm making a LocationListView widget to display a list of Locations.
class LocationListView extends StatefulWidget {
  final List<Location> locationList;
  final LocationController locationController;

  // I require a list of locations to be provided when the widget is created.
  LocationListView(
      {Key? key, required this.locationList, required this.locationController})
      : super(key: key);

  @override
  _LocationListViewState createState() => _LocationListViewState();
}

class _LocationListViewState extends State<LocationListView> {
  // I'll start with an empty list of locations to display.
  List<Location> displayedLocations = [];

  // When the user presses the button, I'll call this method to update the list.
  // void showLocationList() {
  //   // I'm setting the state here to update the displayedLocations with the full list.
  //   setState(() {
  //     displayedLocations = widget.locationList;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // The UI will have a button to display the location list.
    return Scaffold(
      appBar: AppBar(
        title: Text('Location List View'),
      ),
      body: Column(
        children: [
          // This button, when pressed, will display the location's information.
          ElevatedButton(
            onPressed: () =>
                {widget.locationController.createNewLocation(context)},
            child: Text('Add Location'),
          ),
          Expanded(
            // The ListView.builder will display each location's name in a ListTile.
            child: ListView.builder(
              itemCount: widget.locationList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pop(widget.locationList[index]),
                    child: ListTile(
                      title: Text(widget.locationList[index].name),
                      subtitle: Text(
                          "ID: " + widget.locationList[index].uid.toString()),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}

// void main() {
//   // I'm setting up a list of dummy locations for the purpose of this example.
//   List<Location> locations = [
//     Location(name: 'Central Park', description: 'A large public, urban park.'),
//     // ... add more locations here
//   ];

//   // The main function is the entry point of the app, where I run my app with LocationListView.
//   runApp(MaterialApp(home: LocationListView(locationList: locations)));
// }
