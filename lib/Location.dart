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

  String getName() {
    return _name;
  }

  String getDescription() {
    return _description;
  }

  List<String> getBarcodes() {
    return _barcodes;
  }

  List<String> getLocations() {
    return _locations;
  }
}
