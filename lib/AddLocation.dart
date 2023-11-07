import 'Location.dart';
import 'LocationView.dart';
import 'LocationListView.dart';
import 'package:flutter/material.dart';

class LocationView extends StatelessWidget {
  final Location location;

  LocationView(this.location);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location View'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Location Name: ${location.name}'),
            Text('Description: ${location.description}'),
            Text('Barcodes: ${location.barcodes.toString()}'),
            Text('Locations: ${location.locations.toString()}'),
          ],
        ),
      ),
    );
  }
}

class LocationListView extends StatelessWidget {
  final List<Location> locationList;

  LocationListView(this.locationList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location List View'),
      ),
      body: ListView.builder(
        itemCount: locationList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Location Name: ${locationList[index].name}'),
            subtitle: Text('Description: ${locationList[index].description}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationView(locationList[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
