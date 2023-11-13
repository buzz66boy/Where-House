import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeScannerWidget {
  String _barcodeResult = 'No barcode scanned yet';
  void scanBarcode() async {
    try {
      String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // background color
        'Cancel', // cancel button text
        true, // show flash icon
        ScanMode.BARCODE, // barcode mode
      );
      _barcodeResult = barcodeResult;
    } catch (e) {
      _barcodeResult = 'Error: $e';
    }
  }
}
