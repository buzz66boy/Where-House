import 'package:flutter/material.dart';

class LocationView extends StatelessWidget {
  final Location? location;

  LocationView({this.location});

  @override
  Widget build(BuildContext context) {
    if (location != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Location View'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${location!.getName()}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Description: ${location!.getDescription()}'),
              SizedBox(height: 10),
              Text('Barcodes: ${location!.getBarcodes().join(', ')}'),
              SizedBox(height: 10),
              Text('Locations: ${location!.getLocations().join(', ')}'),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Location View'),
        ),
        body: Center(
          child: Text('No location data available.'),
        ),
      );
    }
  }
}
