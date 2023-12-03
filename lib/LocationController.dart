import 'package:flutter/material.dart';
import 'package:wherehouse/Item_Management/Controllers/item_controller.dart';
import 'package:wherehouse/database/Location.dart';
import 'package:wherehouse/database/LocationManager.dart';
import 'LocationView.dart'; // I'm importing the LocationView widget here.
import 'LocationListView.dart'; // Here's where I import the LocationListView widget.

class LocationController {
  final LocationManager locationManager;

  LocationController({required this.locationManager});

  void showLocation(
      {required BuildContext context,
      Location? location,
      int loc_uid = -1}) async {
    if (location == null && loc_uid >= 0) {
      List<Location> locationList =
          await locationManager.queryLocations('$loc_uid');

      for (int i = 0; i < locationList.length; i++) {
        if (locationList[i].uid == loc_uid) {
          location = locationList[i];
          break;
        }
      }
    }
    if (location == null) {
      return; //FIXME: throw exception
    }
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LocationView(
                locationController: this, location: location as Location)));
  }

  Future<Location?> createNewLocation(context) async {
    String? text = await _getLocationName(context);

    if (text != null) {
      Location? newLoc = await locationManager.addLocation(text, -1);

      if (newLoc != null) {
        showLocation(context: context, location: newLoc);
      }
      return newLoc;
    }
    return null;
  }

  Future<String?> _getLocationName(context) async {
    TextEditingController nameController = TextEditingController();
    return showDialog(
        useRootNavigator: false,
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('New Location Name'),
            content: TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: 'Location Name'),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(nameController.text);
                },
                child: Text('Save'),
              ),
            ],
          );
        });
  }

  void showLocationList(
      {required BuildContext context,
      List<Location>? locationList,
      List<int>? locUIDList}) async {
    if (locationList == null) {
      debugPrint("hereeeee");
      //FIXME: handle locUIDList
      locationList = await locationManager.queryLocations();

      debugPrint(locationList.toString());
      if (locationList.isEmpty) {
        locationList = [];
      }
    }
    final locationSelected = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LocationListView(
                locationController: this,
                locationList: locationList as List<Location>)));
    if (locationSelected != null) {
      showLocation(context: context, location: locationSelected);
    }
  }

  Future<List<String>> getLocationNames(List<int> uid_list) async {
    List<String> nameList = [];
    for (int i = 0; i < uid_list.length; i++) {
      String name = await getLocationName(uid_list[i]);
      nameList.add(name);
    }
    return nameList;
  }

  Future<String> getLocationName(int uid) async {
    List<Location> locList =
        await locationManager.queryLocations(uid.toString());

    for (int i = 0; i < locList.length; i++) {
      if (locList[i].uid == uid) {
        return locList[i].name;
      }
    }
    return '';
  }

  Future<Location?> getLocationSelection(
      {required BuildContext context, List<Location>? locList}) async {
    if (locList == null) {
      locList = await locationManager.queryLocations();
    }
    final locationSelected = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LocationListView(
                locationController: this,
                locationList: locList as List<Location>)));
    return locationSelected;
  }

  Future<Location?> editLocation(
      {required int uid, String? name, int? defLoc}) {
    return locationManager.editLocation(
        uid: uid, name: name, defaultLocation: defLoc);
  }

  Future<bool> deleteLocation(int uid) async {
    ItemController itemController = ItemControllerHolder.getInstance();
    Map<int, int> itemQuants = await itemController.getLocationItems(uid);

    itemQuants.forEach((key, value) {
      itemQuants[key] = 0;
    });

    itemController.updateItemLocationQuantities(
        locUid: uid, uidQuantMap: itemQuants);
    return locationManager.removeLocation(uid);
  }
}
// Below is my Location class with properties for name, description, etc.
// class Location {
//   String _name;
//   String _description;
//   List<String> _barcodes;
//   List<String> _locations;

//   Location({
//     required String name,
//     required String description,
//     required List<String> barcodes,
//     required List<String> locations,
//   }) {
//     _name = name;
//     _description = description;
//     _barcodes = barcodes;
//     _locations = locations;
//   }

//   String getName() => _name; // Here I can get the name of the location.
//   String getDescription() => _description; // This lets me get the description.
//   List<String> getBarcodes() =>
//       _barcodes; // Here I can retrieve the list of barcodes.
//   List<String> getLocations() =>
//       _locations; // And this gets me the list of locations.
// }

// This is the main view for my Location app.
// class LocationMainView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:
//             Text('Location Main'), // I'm setting the title of my app bar here.
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             // Below, I've added a button that navigates to the LocationView.
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => LocationView()),
//                 );
//               },
//               child: Text('Location View'),
//             ),
//             // This button is for navigating to the LocationListView.
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => LocationListView()),
//                 );
//               },
//               child: Text('Location List View'),
//             ),
//             // I use this button when I want to add a new location.
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => AddLocation()),
//                 );
//               },
//               child: Text('Add Location'),
//             ),
//             // And this button is for setting information about a location.
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SetLocation()),
//                 );
//               },
//               child: Text('Set Location Info'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // I'm starting my app here with the LocationMainView widget.
// void main() {
//   runApp(MaterialApp(home: LocationMainView()));
// }
