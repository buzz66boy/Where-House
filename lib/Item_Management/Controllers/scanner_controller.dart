import 'dart:async';
import 'dart:io' show Platform;
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wherehouse/Item_Management/Controllers/item_controller.dart';
import 'package:wherehouse/database/Item.dart';

//void main() => runApp(const ScannerController() as Widget);

class ScannerController extends StatefulWidget {
  final ItemController itemController;

  ScannerController({Key? key, required this.itemController}) : super(key: key);
  @override
  State<ScannerController> createState() => _ScannerControllerState();
}

class _ScannerControllerState extends State<ScannerController> {
  ScanResult? scanResult;

  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');

  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final scanResult = this.scanResult;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          title: const Text('Barcode Scanner'),
          actions: [
            IconButton(
              icon: const Icon(Icons.camera_alt),
              tooltip: 'Scan',
              onPressed: _scan,
            ),
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            if (scanResult != null)
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: const Text('Result Type'),
                      subtitle: Text(scanResult.type.toString()),
                    ),
                    ListTile(
                      title: const Text('Raw Content'),
                      subtitle: Text(scanResult.rawContent),
                    ),
                    ListTile(
                      title: const Text('Format'),
                      subtitle: Text(scanResult.format.toString()),
                    ),
                    ListTile(
                      title: const Text('Format note'),
                      subtitle: Text(scanResult.formatNote),
                    ),
                  ],
                ),
              ),
            CheckboxListTile(
              title: const Text('Autofocus'),
              value: _useAutoFocus,
              onChanged: (checked) {
                setState(() {
                  _useAutoFocus = checked!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Flash'),
              value: _autoEnableFlash,
              onChanged: (checked) {
                setState(() {
                  _autoEnableFlash = checked!;
                });
              },
            ),
            const ListTile(
              title: Text('Barcode formats'),
              dense: true,
              enabled: false,
            ),
            ListTile(
              trailing: Checkbox(
                tristate: true,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: selectedFormats.length == _possibleFormats.length
                    ? true
                    : selectedFormats.isEmpty
                        ? false
                        : null,
                onChanged: (checked) {
                  setState(() {
                    selectedFormats = [
                      if (checked ?? false) ..._possibleFormats,
                    ];
                  });
                },
              ),
              dense: true,
              enabled: false,
              title: const Text('Detect barcode formats'),
              subtitle: const Text(
                'Select all fromats',
              ),
            ),
            ..._possibleFormats.map(
              (format) => CheckboxListTile(
                value: selectedFormats.contains(format),
                onChanged: (i) {
                  setState(
                    () => selectedFormats.contains(format)
                        ? selectedFormats.remove(format)
                        : selectedFormats.add(format),
                  );
                },
                title: Text(format.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': _cancelController.text,
            'flash_on': _flashOnController.text,
            'flash_off': _flashOffController.text,
          },
          restrictFormat: selectedFormats,
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      debugPrint("Scanned!");
      // setState(() => scanResult = result);
      if (result != null) {
        widget.itemController.itemScanned(context, scanResult.toString());
      }
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }
}
